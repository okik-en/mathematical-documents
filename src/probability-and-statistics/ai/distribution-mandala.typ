#import "@preview/cetz:0.5.2"
#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "分布の曼陀羅",
  description: "統計検定2級に登場する確率分布どうしの関係を1枚の図にまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "確率分布", "標本分布"),
)

#show: previewer(document-config)

#let Ex = math.class("normal", math.italic("Ex"))

統計検定2級に登場する分布は、ばらばらに覚えるより*「どの分布から、どう作られるか」*の関係で覚えたほうが整理しやすい。
その関係を1枚にまとめたものを、ここでは*分布の曼陀羅*と呼ぶ。

各分布の定義は#link("../probability-distributions/")[確率分布のまとめ]と#link("../sampling-distributions/")[標本分布のまとめ]を参照のこと。

= 曼陀羅

#let discrete = rgb("#dbeafe")
#let continuous = rgb("#dcfce7")
#let normal = rgb("#fef3c7")
#let sampling = rgb("#fce7f3")

#let nodes = (
  bern: ((4.5, 9), [ベルヌーイ分布\ $display(B(1, p))$], discrete),
  geo: ((14.5, 9), [幾何分布\ $display(G(p))$], discrete),
  nb: ((19.5, 9), [負の二項分布\ $display(N B(r, p))$], discrete),
  hyper: ((0, 6), [超幾何分布\ $display(Hyper(N, M, n))$], discrete),
  bin: ((4.5, 6), [二項分布\ $display(Bin(n, p))$], discrete),
  po: ((9.5, 6), [ポアソン分布\ $display(Po(lambda))$], discrete),
  exp: ((14.5, 6), [指数分布\ $display(Ex(lambda))$], continuous),
  gamma: ((19.5, 6), [$Gamma$分布\ $display(Gamma(alpha, lambda))$], continuous),
  unif: ((14.5, 3), [一様分布\ $display(U(0, 1))$], continuous),
  bvn: ((0, 0), [2変量正規分布], normal),
  norm: ((4.5, 0), [正規分布\ $display(N(mu, sigma^2))$], normal),
  z: ((9.5, 0), [標準正規分布\ $display(N(0, 1))$], normal),
  chi: ((19.5, 0), [$chi^2$分布\ $display(chi^2(n))$], sampling),
  t: ((14.5, -3), [$t$分布\ $display(t(n))$], sampling),
  f: ((19.5, -3), [$F$分布\ $display(F(m, n))$], sampling),
)

// 式の中で、その矢印に関係する部分を赤、それ以外を灰色にする
#let hl(x) = text(fill: rgb("#dc2626"), x)
#let dim(x) = text(fill: luma(140), x)

// (始点, 終点, ラベル, 極限・近似か, 線を左にずらす距離[, ラベルを置く側：1 = 左, -1 = 右[, 両矢印か]])
#let edges = (
  ("bern", "bin", [$display(n)$個の和], false, 0),
  ("bern", "geo", [初成功まで], false, 0),
  ("geo", "nb", [$display(r)$個の和], false, 0),
  ("hyper", "bin", [$display(N -> infinity)$], true, 0),
  ("bin", "po", [$display(n -> infinity)$\ $display(n p = lambda)$], true, 0),
  ("bin", "norm", [$display(n -> infinity)$], true, 0),
  ("po", "norm", [$display(lambda -> infinity)$], true, 0),
  ("po", "exp", [回数と間隔], false, 0, 1, true),
  ("geo", "exp", [連続化], true, 0),
  ("nb", "gamma", [連続化], true, 0),
  ("exp", "gamma", [$display(alpha)$個の和], false, 0),
  ("unif", "exp", [$display(-1/lambda log U)$], false, 0),
  ("bvn", "norm", [周辺分布], false, 0),
  ("norm", "z", [標準化], false, 0),
  ("gamma", "chi", [$display(alpha = n/2)$\ $display(lambda = 1/2)$], false, 0),
  ("z", "chi", [2乗して$display(n)$個の和], false, 0),
  ("z", "t", [$display(hl(Z) dim("/" sqrt(X "/" n)))$], false, .15),
  ("t", "z", [$display(n -> infinity)$], true, .15),
  ("chi", "t", [$display(dim(Z "/" sqrt(hl(X) "/" n)))$], false, 0, -1),
  ("chi", "f", [$display(frac(X "/" m, Y "/" n))$], false, 0),
  ("t", "f", [2乗], false, 0),
)

// ラベルを置く側（線の左側の法線方向）から、ラベルのどの角を線に寄せるかを決める
#let _anchors = ("east", "north-east", "north", "north-west", "west", "south-west", "south", "south-east")
#let _anchor-toward(angle) = _anchors.at(calc.rem-euclid(int(calc.round(angle / 45deg)), 8))

#let mandala = cetz.canvas(length: .8cm, {
  import cetz.draw: *

  for (name, (pos, body, color)) in nodes {
    content(
      pos,
      align(center, text(size: 9pt, body)),
      name: name,
      frame: "rect",
      padding: .2,
      fill: color,
      stroke: .6pt + luma(80),
    )
  }

  for (from, to, label, limit, shift, ..rest) in edges {
    let side = rest.at(0, default: 1)
    let both = rest.at(1, default: false)
    let (p, _, _) = nodes.at(from)
    let (q, _, _) = nodes.at(to)
    let angle = calc.atan2(q.at(0) - p.at(0), q.at(1) - p.at(1))
    // 箱の縁どうしを結ぶ中心線。shift があれば、往復の矢印が重ならないよう両端を同じだけ左へ平行移動する
    let a = (name: from, anchor: angle)
    let b = (name: to, anchor: angle + 180deg)
    if shift != 0 {
      let d = (calc.cos(angle + 90deg) * shift, calc.sin(angle + 90deg) * shift)
      a = (rel: d, to: (a, .1, b))
      b = (rel: d, to: (b, .1, a))
    }
    line(
      a,
      b,
      mark: (start: if both { ">" }, end: ">", fill: black),
      stroke: if limit { (paint: luma(60), thickness: .7pt, dash: "dashed") } else { .7pt + black },
    )
    // 線の左側（曲げた側）に少し離してラベルを置き、線や矢印の頭に重ならないようにする
    let normal = angle + side * 90deg
    content(
      (rel: (calc.cos(normal) * .12, calc.sin(normal) * .12), to: (a, 50%, b)),
      box(inset: 1pt, {
        set par(leading: .4em)
        set text(top-edge: "bounds", bottom-edge: "bounds")
        align(center, text(size: 7.5pt, label))
      }),
      anchor: _anchor-toward(normal + 180deg),
    )
  }
})

#figure(caption: [分布の曼陀羅], frame(mandala))

#table(
  columns: 2,
  [*記号*], [*意味*],
  [実線の矢印], [和・変換・特別な場合（ちょうどその分布になる）],
  [破線の矢印], [極限・近似（パラメータを動かすと近づく）],
  [青], [離散型の分布],
  [緑], [連続型の分布],
  [黄], [正規分布の仲間],
  [赤], [正規分布から作る標本分布],
)

= 矢印の意味

== ベルヌーイ分布から広がる離散分布

#table(
  columns: 2,
  [*関係*], [*内容*],
  [ベルヌーイ → 二項], [独立な$B(1, p)$を$n$個足すと$Bin(n, p)$],
  [ベルヌーイ → 幾何], [$B(1, p)$を繰り返し、初めて成功するまでの失敗回数が$G(p)$],
  [幾何 → 負の二項], [独立な$G(p)$を$r$個足すと$N B(r, p)$（$r$回目の成功まで）],
  [超幾何 → 二項], [母集団$N -> infinity$（$M/N = p$一定）で、非復元抽出が復元抽出と変わらなくなる],
  [二項 → ポアソン], [$n -> infinity$、$p -> 0$（$n p = lambda$一定）の極限。稀な事象の回数],
  [二項 → 正規], [$n$が大きいと$N(n p, n p (1 - p))$で近似できる（中心極限定理）],
  [ポアソン → 正規], [$lambda$が大きいと$N(lambda, lambda)$で近似できる],
)

== 回数と時間の対応

#table(
  columns: 2,
  [*関係*], [*内容*],
  [ポアソン ⇄ 指数], [単位時間に平均$lambda$回起こるとき、時刻$t$までの回数が$Po(lambda t)$、発生の間隔が$Ex(lambda)$。同じ現象を回数と時間の両側から見たもの（#link("../probability-distributions/")[確率分布のまとめ]の「ポアソン過程」の節を参照）],
  [幾何 → 指数], [「何回目で起こるか」を連続時間にした極限。どちらも*無記憶性*をもつ],
  [負の二項 → $Gamma$], [「$r$回目まで」を連続時間にした極限],
  [指数 → $Gamma$], [独立な$Ex(lambda)$を$alpha$個足すと$Gamma(alpha, lambda)$。$Ex(lambda) = Gamma(1, lambda)$],
  [一様 → 指数], [$U tilde.op U(0, 1)$なら$-1/lambda log U tilde.op Ex(lambda)$（逆関数法による乱数生成）],
)

== 正規分布と標本分布

#table(
  columns: 2,
  [*関係*], [*内容*],
  [2変量正規 → 正規], [2変量正規分布の周辺分布・条件付き分布は正規分布],
  [正規 → 標準正規], [$X tilde.op N(mu, sigma^2)$なら$frac(X - mu, sigma) tilde.op N(0, 1)$],
  [標準正規 → $chi^2$], [独立な$Z_i tilde.op N(0, 1)$について$Z_1^2 + dots.c + Z_n^2 tilde.op chi^2(n)$],
  [$Gamma$ → $chi^2$], [$chi^2(n) = Gamma(n/2, 1/2)$。とくに$chi^2(2) = Ex(1/2)$],
  [標準正規・$chi^2$ → $t$], [$Z "/" sqrt(X "/" n) tilde.op t(n)$（$Z tilde.op N(0, 1)$、$X tilde.op chi^2(n)$独立）],
  [$t$ → 標準正規], [$n -> infinity$で$t(n) -> N(0, 1)$],
  [$chi^2$ → $F$], [$frac(X "/" m, Y "/" n) tilde.op F(m, n)$（$X tilde.op chi^2(m)$、$Y tilde.op chi^2(n)$独立）],
  [$t$ → $F$], [$T tilde.op t(n)$なら$T^2 tilde.op F(1, n)$],
)

= 覚え方

#memo(title: "3つの系統")[
  + *数える系*（離散）：ベルヌーイ → 二項 → ポアソン。「何回起こったか」
  + *待つ系*：幾何 → 負の二項（離散）、指数 → $Gamma$（連続）。「いつ起こるか」
  + *正規系*：正規 → $chi^2$ → $t$、$F$。「標本から母集団を推測する」
]

#memo(title: "離散と連続のペア")[
  #table(
    columns: 3,
    [*意味*], [*離散*], [*連続*],
    [1回目までの待ち], [幾何分布], [指数分布],
    [$r$回目までの待ち], [負の二項分布], [$Gamma$分布],
    [無記憶性をもつ], [幾何分布], [指数分布],
  )
  離散の「回数」を連続の「時間」に置き換えると、ちょうど対応する分布になる。
]

#memo(title: "「足すと同じ分布」になるもの（再生性）")[
  二項（$p$が同じ）、ポアソン、負の二項（$p$が同じ）、正規、$Gamma$（$lambda$が同じ）、$chi^2$。
  曼陀羅の「$n$個の和」「$alpha$個の和」の矢印は、すべて再生性の現れである。
]

#memo(title: "最後は正規分布に集まる")[
  二項・ポアソン・$t$の破線の矢印は、どれも正規分布に向かう。
  「たくさん足す」「自由度を大きくする」と正規分布になるのは、中心極限定理のおかげ。
  迷ったら「$n$が大きければ正規近似」と考えてよい。
]
