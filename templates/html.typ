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

#let html-init(body) = context {
  let is-html = not sys.inputs.keys().contains("x-preview") and target() == "html"

  //* MARK: フォントの調整

  // ベースフォント
  set text(
    font: family.serif,
    cjk-latin-spacing: auto,
    top-edge: "ascender",
    bottom-edge: "descender",
    number-type: "lining",
    number-width: "tabular",
    size: if is-html { 14pt } else { 11pt },
  )
  show title: set text(font: family.sans)
  show heading: set text(font: family.sans)
  show strong: set text(font: family.sans)
  show raw: set text(font: family.mono)
  show math.equation: set text(font: family.math)

  //* MARK: 数式の調整

  // インライン数式
  show math.equation.where(block: false): it => if is-html {
    html.elem(
      "span",
      attrs: (
        class: "inline",
        role: "math",
        alt: if it.alt == none { repr(it.body).replace(regex("\n\s*"), _ => "") } else { it.alt },
      ),
      html.frame(it),
    )
  } else { it }
  // ブロック数式
  show math.equation.where(block: true): it => if is-html {
    html.elem(
      "div",
      attrs: (
        class: "display",
        role: "math",
        alt: if it.alt == none { repr(it.body).replace(regex("\n\s*"), _ => "") } else { it.alt },
      ),
      html.frame(it),
    )
  } else { it }

  //* MARK: インデントの調整

  let __after-block__ = state("__after-block__", false)
  let erase(it, f: true) = {
    it
    __after-block__.update(f)
  }
  show math.equation.where(block: true): erase
  show enum: erase
  show list: erase
  show terms: erase
  show align: erase
  show raw: erase
  show parbreak: erase.with(f: false)
  show par: it => context {
    if not it.first-line-indent.amount == 0em and __after-block__.get() {
      __after-block__.update(false)
      let (..args, body) = it.fields()
      par(..args, first-line-indent: 0em, body)
    } else {
      it
    }
  }

  //* MARK: プレビュー

  // ページ設定
  set page(height: auto, margin: (left: 25mm, right: 25mm, top: 30mm, bottom: 30mm)) if (not is-html)

  show strong: it => if is-html {
    html.elem("strong", attrs: (class: "strong"), it)
  } else {
    underline(it, stroke: (dash: "densely-dashed"))
  }

  //* MARK: HTMLエクスポート

  let css-relative-path = if "out-path" in sys.inputs and "stylesheet-path" in sys.inputs {
    let out-path = sys.inputs.at("out-path")
    let css-path = sys.inputs.at("stylesheet-path")
    if type(out-path) == str {
      let back = out-path.split("/").slice(2).map(_ => "..").join("/")
      if back == none { back = "." }
      back + "/" + css-path.replace(regex("^.*/"), "")
    }
  } else {
    none
  }
  if is-html {
    html.html(lang: "ja", {
      // <head> ~ </head>
      html.head({
        html.meta(charset: "utf-8")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.title(document.title)
        if document.description != none {
          html.meta(name: "description", content: document.description)
        }
        // html.link(rel: "preconnect", href: "https://fonts.googleapis.com")
        // html.link(rel: "preconnect", href: "https://fonts.gstatic.com", crossorigin: "anonymous")

        // html.script(src: "script.js")
        html.link(rel: "stylesheet", href: css-relative-path)
      })
      // <body> ~ </body>
      html.body({
        html.div(class: "container", {
          html.main(body)
          // html.aside(outline())
        })
      })
    })
  } else { body }
}

#let author() = context {
  let is-html = not sys.inputs.keys().contains("x-preview") and target() == "html"
  if is-html {
    html.div(class: "author", "Authored by: " + document.author.join(", "))
  } else {
    align(right, "Authored by: " + document.author.join(", "))
  }
}
