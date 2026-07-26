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
  set list(indent: 2em, body-indent: 0.4em, spacing: 0.5em)
  set enum(indent: 2em, body-indent: 0.4em, spacing: 0.5em)
  set terms(indent: 2em, spacing: 0.5em)
  set grid(gutter: 2em, align: top)

  // 数式
  show math.equation: it => math.display(it)
  set math.accent(size: 150%)

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
