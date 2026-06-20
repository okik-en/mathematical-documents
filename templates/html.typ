#import "fonts.typ": *

#let __in-frame__ = state("__in-frame__", false)

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
  show math.equation.where(block: false): it => if is-html and not __in-frame__.get() {
    html.span(
      style: "display:inline-table;margin-inline:.25em;vertical-align:middle;overflow-x:auto;",
      role: "math",
      html.frame(it),
    )
  } else { it }
  // ブロック数式
  show math.equation.where(block: true): it => if is-html and not __in-frame__.get() {
    html.div(
      style: "display:block;overflow-x:auto;text-align:center;",
      role: "math",
      html.div(
        style: "display:inline-block;",
        html.frame(it),
      ),
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

  show par: it => context {
    if is-html {
      if it.first-line-indent.amount == 0em {
        html.div(class: "no-indent", it)
      } else {
        it
      }
    } else {
      it
    }
  }

  assert.ne(document.title, none, message: "Document title must be specified")

  if is-html {
    let title = (
      if document.title == none { "無題" } else {
        repr(document.title).slice(1, -1)
      }
    )
    let doc-type = if sys.inputs.at("rel", default: none) != "index.typ" { "article" } else { "website" }
    html.html(lang: "ja", {
      // <head> ~ </head>
      html.head({
        html.meta(charset: "utf-8")
        html.meta(name: "viewport", content: "width=device-width, initial-scale=1")
        html.title(title)
        html.elem("meta", attrs: (property: "og:title", content: title))
        if document.description != none {
          html.meta(name: "description", content: document.description)
          html.elem("meta", attrs: (property: "og:description", content: document.description))
        }
        html.elem("meta", attrs: (property: "og:url", content: sys.inputs.at("url", default: "")))
        html.elem("meta", attrs: (
          property: "og:image",
          content: "https://avatars.githubusercontent.com/u/258426464",
        ))
        html.elem("meta", attrs: (property: "og:type", content: doc-type))
        html.elem("meta", attrs: (
          property: "og:site_name",
          content: "数学的読み物置き場",
        ))
        html.elem("meta", attrs: (
          property: "og:locale",
          content: "ja_JP",
        ))

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

#let tree(body) = context {
  let is-html = not sys.inputs.keys().contains("x-preview") and target() == "html"
  if is-html {
    html.div(class: "tree", body)
  } else {
    body
  }
}

#let frame-it(it) = context {
  let is-html = not sys.inputs.keys().contains("x-preview") and target() == "html"
  if is-html {
    __in-frame__.update(true)
    html.frame(it)
    __in-frame__.update(false)
  } else {
    it
  }
}
