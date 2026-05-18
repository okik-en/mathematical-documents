#let html-init(body) = context {
  let is-html = not sys.inputs.keys().contains("x-preview") and target() == "html"

  //* MARK: 数式の調整

  // インライン数式
  show math.equation.where(block: false): it => if is-html {
    html.elem(
      "span",
      attrs: (class: "inline", role: "math", alt: if it.alt == none { repr(it.body) } else { it.alt }),
      html.frame(it),
    )
  } else { it }
  // ブロック数式
  show math.equation.where(block: true): it => if is-html {
    html.elem(
      "div",
      attrs: (class: "display", role: "math", alt: if it.alt == none { repr(it.body) } else { it.alt }),
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
        let css-path = sys.inputs.at("css-path", default: "../style.css")
        html.link(rel: "stylesheet", href: css-path)
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
    html.div(class: "author", document.author.join(", "))
  } else {
    align(right, document.author.join(", "))
  }
}
