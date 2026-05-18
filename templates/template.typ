#import "@preview/cjk-spacer:0.2.0": cjk-spacer

#let emoji-regex = regex("[\u{2600}-\u{27BF}\u{1F000}-\u{1FFFF}]")

#let fonts = (
  serif: "New Computer Modern",
  serif-cjk: "Yu Mincho",
  sans: "Arial",
  sans-cjk: "Yu Gothic",
  mono: "Fira Code",
  mono-cjk: "Yu Gothic UI",
  math: "New Computer Modern Math",
  emoji: "Noto Emoji",
)

#let family = (
  serif: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
  sans: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.sans, covers: "latin-in-cjk"), fonts.sans-cjk),
  mono: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.mono, covers: "latin-in-cjk"), fonts.mono-cjk),
  math: (fonts.math, (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
)

#let okik-en-data = (
  authors: (salty-lemon: "Salty Lemon " + emoji.lemon),
)

// = template初期化関数
// `template()`
// #parbreak()
// カスタマイズされたテンプレート。
// == 使用例
// ```typ
// #show: template
// ```
#let template(
  par-leading: 0.8em,
  par-indent: 1em,
  body,
) = {
  set text(lang: "ja")

  //* MARK:フォント関連

  // ベースフォント
  set text(
    font: family.serif,
    cjk-latin-spacing: auto,
    top-edge: "ascender",
    bottom-edge: "descender",
    number-type: "lining",
    number-width: "tabular",
  )
  show title: set text(font: family.sans)
  show heading: set text(font: family.sans)
  show strong: set text(font: family.sans)
  show raw: set text(font: family.mono)
  show math.equation: set text(font: family.math)

  //* MARK:カウンタ関連

  // カウンタリセット
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)
    it
  }

  // 章番号
  set heading(numbering: "1.1.1.")

  // 図表番号
  set figure(
    numbering: num => numbering("1.1", counter(heading).get().first(), num),
  )
  show figure.where(kind: image): set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: raw): set figure(supplement: [コード])

  // 数式番号 (通常は表示しない)
  set math.equation(numbering: none)

  //* MARK:スタイルシート

  // 段落
  set par(first-line-indent: (amount: par-indent, all: true), justify: true, leading: par-leading)

  // 傍線
  set underline(extent: 1pt, offset: 2pt)

  // リスト
  set list(indent: 0.6em, body-indent: 0.4em, spacing: 0.5em)
  set enum(indent: 0.6em, body-indent: 0.4em, spacing: 0.5em)

  // 本文
  body
}

// = 参照付き数式
// `eqref(ref: reference, body: content)`
// #parbreak()
// ブロック数式をあえて番号付けする際に使用。
// == 使用例
// ```typ
// #eqref(<example>)[
//   $ nabla dot.c bb(B) = 0 $
// ]
// 磁場のガウスの法則#[@example]より…
// ```
#let eqref(ref, body) = {
  [
    #math.equation(
      block: true,
      numbering: num => numbering(
        "(1.1)",
        counter(heading).get().first(),
        num,
      ),
      number-align: right + horizon,
      body,
    )
    #ref
  ]
}
