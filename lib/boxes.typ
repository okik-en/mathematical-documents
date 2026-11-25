#import "utils.typ": is-preview, styled

#let _box(label, color, title, body) = {
  let heading = if title == none [#label] else [#label：#title]
  if is-preview {
    block(
      width: 100%,
      inset: (x: 10pt, y: 8pt),
      fill: color.transparentize(88%),
      stroke: (left: 3pt + color),
      {
        text(weight: "bold", fill: color, heading)
        parbreak()
        body
      },
    )
  } else {
    html.div(
      style: styled(
        border-left: "4px solid " + color.to-hex(),
        background-color: color.transparentize(88%).to-hex(),
        border-radius: "4px",
        padding: ".25em 1em",
        margin: "1em 0",
      ),
      {
        html.p(style: styled(font-weight: "bold", color: color.to-hex(), margin: ".5em 0"), heading)
        body
      },
    )
  }
}

#let motivation(title: none, body) = _box("動機", rgb("#0891b2"), title, body)
#let definition(title: none, body) = _box("定義", rgb("#2563eb"), title, body)
#let theorem(title: none, body) = _box("定理", rgb("#059669"), title, body)
#let memo(title: none, body) = _box("覚え方", rgb("#d97706"), title, body)
#let caution(title: none, body) = _box("注意", rgb("#dc2626"), title, body)
#let example(title: none, body) = _box("例題", rgb("#7c3aed"), title, body)
