// textlint-plugin-typst をラップして、Typst の文を日本語の文として lint しやすい形に直してから渡す。
//   1. 数式 $...$ と #eqref(...) をプレースホルダ（既定は "X"）に置き換える
//   2. #link(...)[本文] などのインライン関数を本文だけにする
//   3. 強調 *…* を Markdown と同じ **…** にする（preset-ai-writing が ** の並びを探すため）
//   4. 箇条書きの中で半角スペースによって分割された Str や、強調で分割された Str を 1 つに戻す（括弧の対応などが崩れるため）
//   5. コードの中のコメントを消す
//   6. 句点のルールを止める：コードの中の content（表のセル・title・caption・図のラベルなど）、数式だけの段落、箇条書きや数式ブロックに続く段落
// 指摘の位置は postProcess で元のソースの位置に戻す。
import typstModule from "textlint-plugin-typst";
const TypstProcessor = (typstModule.default ?? typstModule).Processor;

const DEFAULTS = {
  placeholder: "X",
  replaceFunctions: ["eqref"],
  inlineFunctions: ["link", "text", "strong", "emph", "highlight", "underline", "smallcaps"],
  periodRules: ["ja-no-mixed-period"],
  markdownStrong: true,
};

const walk = (node, fn, parent = null) => {
  if (fn(node, parent) === false) return;
  for (const c of node.children ?? []) walk(c, fn, node);
};
const funcName = (call) => call.children?.find((c) => c.type.startsWith("Fn::(Ident"))?.raw;
const argsOf = (call) => call.children?.find((c) => c.type === "Marked::Args");

// 数式ブロックの置き換え先。このリポジトリでは数式ブロックの後に「。」を付けないので、
//   直前で文が終わっている（「。」の後）     → 消す
//   直後で段落が終わる（空行・箇条書き・閉じ括弧など） → "X。"（数式で文が終わる）
//   それ以外（「…とすると $ … $ となる。」）   → "X"（文の途中）
// #eqref(...) も数式ブロックとして同じように扱う。
const displayMath = (text, [s, e], placeholder) => {
  const before = text.slice(0, s).trimEnd();
  if (before === "" || /[。．]$/.test(before)) return "";
  if (/^[ \t]*(\n[ \t]*\n|\n?[ \t]*$|\n[ \t]*[#=+\/\]-]|[ \t]*[\],)])/.test(text.slice(e))) return placeholder + "。";
  return placeholder;
};

// 元のテキストに対する編集 [start, end, 置換文字列] を集める
const collectEdits = (ast, text, opt) => {
  const edits = [];
  walk(ast, (node) => {
    if ((node.type === "Code" || node.type === "CodeBlock") && node.raw?.startsWith("$")) {
      edits.push([node.range[0], node.range[1], node.type === "CodeBlock" ? displayMath(text, node.range, opt.placeholder) : opt.placeholder]);
      return false;
    }
    if (node.type === "Strong" && opt.markdownStrong && node.raw?.startsWith("*") && node.raw.endsWith("*")) {
      edits.push([node.range[0], node.range[0] + 1, "**"]);
      edits.push([node.range[1] - 1, node.range[1], "**"]);
      // 強調の中の数式は textlint-plugin-typst が Str のまま渡してくるので、ここで置き換える
      for (const m of node.raw.matchAll(/\$(?:\\.|[^$\\])*\$/g)) {
        const ms = node.range[0] + m.index;
        edits.push([ms, ms + m[0].length, opt.placeholder]);
      }
      return false;
    }
    // コードの中のコメントは textlint-plugin-typst が段落として渡してくるので消す
    if (node.type === "Paragraph" && /^\/\/|^\/\*/.test(node.raw ?? "")) {
      edits.push([node.range[0], node.range[1], ""]);
      return false;
    }
    if (node.type !== "Marked::FuncCall") return;
    const name = funcName(node);
    const start = text[node.range[0] - 1] === "#" ? node.range[0] - 1 : node.range[0];
    if (opt.replaceFunctions.includes(name)) {
      edits.push([start, node.range[1], displayMath(text, [start, node.range[1]], opt.placeholder)]);
      return false;
    }
    if (opt.inlineFunctions.includes(name)) {
      const args = argsOf(node);
      const body = args?.children?.filter((c) => c.type === "Paragraph").at(-1);
      if (body) {
        edits.push([start, body.range[0], ""]);
        edits.push([body.range[1], node.range[1], ""]);
      }
    }
  });
  edits.sort((a, b) => a[0] - b[0]);
  const kept = [];
  let end = 0;
  for (const e of edits) if (e[0] >= end) { kept.push(e); end = e[1]; }
  return kept;
};

// 句点のルールを止める範囲：コードの中（丸括弧の中の引数、配列、辞書など）にある content と、数式だけの段落（置換後のテキスト基準）。
// 関数の後ろに付く [本文] は文章として扱う（ただしコードの中の関数呼び出しは除く）。
const collectCodeContent = (ast, placeholder) => {
  const ranges = [];
  const onlyMath = (p) => (p.raw ?? "").split(placeholder).join("").replace(/[。\s]/g, "") === "";
  const visit = (node, inCode) => {
    if (node.type === "Paragraph") {
      if (inCode || onlyMath(node)) ranges.push(node.range); // 数式だけの段落も句点のルールから外す
      inCode = false; // content の中は再び文章
    }
    if (node.type === "Marked::Args") {
      let afterParen = !node.children.some((c) => c.type === "Punc::LeftParen");
      for (const c of node.children) {
        if (c.type === "Punc::RightParen") afterParen = true;
        visit(c, inCode || !afterParen);
      }
      return;
    }
    const code = inCode || (node.type.startsWith("Marked::") && node.type !== "Marked::FuncCall");
    for (const c of node.children ?? []) visit(c, code);
  };
  visit(ast, false);
  // 次に箇条書きや数式ブロックが来る段落（「…とすれば」+ 箇条書き など）は文が続いているとみなす
  const continues = (n) => n && (n.type === "List" || n.type === "ListItem" || n.type === "CodeBlock" || (n.type === "Paragraph" && onlyMath(n)));
  walk(ast, (node) => {
    const cs = (node.children ?? []).filter((c) => c.type !== "Break" && !(c.type === "Str" && c.raw.trim() === ""));
    cs.forEach((c, i) => { if (c.type === "Paragraph" && continues(cs[i + 1])) ranges.push(c.range); });
  });
  return ranges;
};

// textlint-plugin-typst は箇条書きの中の文を半角スペースで別々の Str に分けてしまうので、
// 空白だけを挟んで隣り合う Str をまとめる
const mergeStr = (node, text) => {
  if (!node.children) return;
  const merged = [];
  for (let c of node.children) {
    // 強調も地の文の Str に戻す（「…*強調*…」の括弧の対応を見るため）。** は残るので ai-writing は検出できる
    if (c.type === "Strong") {
      const raw = text.slice(c.range[0], c.range[1]);
      c = { type: "Str", value: raw, raw, range: c.range, loc: c.loc };
    }
    const last = merged.at(-1);
    if (c.type === "Str" && last?.type === "Str" && /^[ \t]*$/.test(text.slice(last.range[1], c.range[0]))) {
      const raw = text.slice(last.range[0], c.range[1]);
      merged[merged.length - 1] = { ...last, value: raw, raw, range: [last.range[0], c.range[1]], loc: { start: last.loc.start, end: c.loc.end } };
    } else {
      merged.push(c);
    }
  }
  node.children = merged;
  node.children.forEach((c) => mergeStr(c, text));
};

const lineStarts = (text) => {
  const s = [0];
  for (let i = 0; i < text.length; i++) if (text[i] === "\n") s.push(i + 1);
  return s;
};
const toLoc = (starts, idx) => {
  let lo = 0, hi = starts.length - 1;
  while (lo < hi) { const m = (lo + hi + 1) >> 1; if (starts[m] <= idx) lo = m; else hi = m - 1; }
  return { line: lo + 1, column: idx - starts[lo] + 1 };
};

// textlint は複数ファイルを並行に処理するが、textlint-plugin-typst の wasm パーサを
// 並行に呼ぶと "memory access out of bounds" で落ちるので、パースを 1 つずつ行う
let queue = Promise.resolve();
const serial = (fn) => {
  const run = queue.then(fn, fn);
  queue = run.catch(() => {});
  return run;
};

export class Processor {
  constructor(options = {}) {
    this.opt = { ...DEFAULTS, ...options };
    this.inner = new TypstProcessor(options);
    this.states = new Map();
  }
  static availableExtensions() { return [".typ"]; }
  processor(ext) {
    const inner = this.inner.processor(ext);
    return {
      preProcess: (text, filePath) => serial(async () => {
        const edits = collectEdits(await inner.preProcess(text, filePath), text, this.opt);
        // segs: [新start, 元start, 新end, 元end, 置換か]
        const segs = [];
        let out = "", prev = 0;
        const push = (s, e, rep) => {
          segs.push([out.length, s, out.length + rep.length, e, s !== e || rep !== ""]);
          out += rep;
        };
        for (const [s, e, rep] of edits) {
          push(prev, s, text.slice(prev, s));
          segs.at(-1)[4] = false;
          push(s, e, rep);
          prev = e;
        }
        push(prev, text.length, text.slice(prev));
        segs.at(-1)[4] = false;
        const ast = await inner.preProcess(out, filePath);
        mergeStr(ast, out);
        this.states.set(filePath, { segs, starts: lineStarts(text), noPeriod: collectCodeContent(ast, this.opt.placeholder) });
        return { text: out, ast };
      }),
      postProcess: async (messages, filePath) => {
        const { segs, starts, noPeriod } = this.states.get(filePath);
        this.states.delete(filePath);
        const map = (i) => {
          const g = segs.find(([ns, , ne]) => ns <= i && i < ne) ?? segs.findLast(([ns]) => ns <= i) ?? segs[0];
          return g[4] ? g[1] : g[1] + (i - g[0]);
        };
        const inNoPeriod = (i) => noPeriod.some(([s, e]) => s <= i && i <= e);
        const result = messages
          .filter((m) => !(this.opt.periodRules.some((r) => m.ruleId?.endsWith(r)) && inNoPeriod(m.range?.[0] ?? m.index)))
          .map((m) => {
            const [s, e] = m.range ?? [m.index, m.index];
            const os = map(s), oe = Math.max(os, map(e));
            const ls = toLoc(starts, os), le = toLoc(starts, oe);
            const r = { ...m, index: os, range: [os, oe], line: ls.line, column: ls.column, loc: { start: ls, end: le } };
            if (m.fix) {
              const [fs, fe] = m.fix.range;
              const touches = segs.some(([ns, , ne, , rep]) => rep && fs < ne && ns < fe);
              if (touches) delete r.fix; else r.fix = { ...m.fix, range: [map(fs), map(fe)] };
            }
            return r;
          });
        return inner.postProcess(result, filePath);
      },
    };
  }
}
export default { Processor };
