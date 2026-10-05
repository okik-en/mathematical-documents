#import "@preview/cetz:0.5.2"

// MARK: MATH
#let Var = math.class("normal", "Var")
#let Cov = math.class("normal", "Cov")
#let Bin = math.class("normal", math.italic("Bin"))
#let Po = math.class("normal", math.italic("Po"))
#let Hyper = math.class("normal", "Hyper")
#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)


// MARK: PREVIEW
#let is-preview = sys.inputs.keys().contains("x-preview")
#let previewer(document-config) = body => if is-preview {
  set document(..document-config)
  set page(height: auto)
  set text(font: "Noto Sans JP", lang: "ja")
  show math.equation: set text(font: "Noto Sans Math")

  title()
  outline()
  body
} else { body }

// MARK: CSS
#let styled(..args) = args.named().pairs().map(((k, v)) => k + ": " + v + ";").join(" ")

// MARK: SVG
#let __svg__ = state("__svg__", false)
#let frame(it) = context if is-preview { it } else {
  __svg__.update(_ => true)
  html.div(
    style: styled(
      width: "fit-content",
      background-color: "white",
      margin: ".5em",
      padding: ".5em",
      overflow-x: "auto",
      display: "inline-block",
    ),
    html.frame(it),
  )
  __svg__.update(_ => false)
}

// MARK: PATH
#let nav(path) = html.nav(html.code({
  let l = path.split("/").len()
  (
    "mdocs:"
      + ("~/" + path)
        .split("/")
        .enumerate()
        .map(((i, e)) => if i == l { e } else { link("../" * (l - i), e) })
        .intersperse("/")
        .join()
      + ">"
  )
}))

// MARK: REPR
#let myrepr(it) = {
  let sequence = [$a$ b].func()
  let symb = [--].func()

  if it == none {
    "none"
  } else if it.func() == text or it.func() == raw or it.func() == symb {
    str(it.at("text"))
  } else if it.func() == math.attach {
    str(myrepr(it.fields().at("base")) + "^" + myrepr(it.fields().at("t")))
  } else if it.func() == math.equation {
    myrepr(it.body)
  } else if it.func() == sequence {
    it.fields().children.map(myrepr).join()
  } else { panic() }
}

// MARK: REF
#let eqref(ref, body) = if is-preview [
  #math.equation(
    block: true,
    numbering: numbering.with("[1]"),
    number-align: right + horizon,
    body,
  )
  #ref
] else {
  html.div(
    style: styled(
      display: "flex",
      justify-content: "space-between",
      align-items: "center",
      gap: "1em",
    ),
    {
      html.div(style: styled(flex: "1"), [
        #math.equation(
          block: true,
          numbering: numbering.with("[1]"),
          number-align: right + horizon,
          body,
        )
        #ref
      ])
      html.div(style: styled(min-width: "2em"), context numbering("[1]", counter(math.equation).get().first()))
    },
  )
}
