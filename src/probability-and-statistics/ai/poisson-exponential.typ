#import "@preview/cetz:0.5.2"
#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let Ex = math.class("normal", math.italic("Ex"))

#let _purple = rgb("#7c6fcd")
#let _teal = rgb("#0e7490")
#let _red = rgb("#dc2626")
#let _axis = (paint: luma(110), thickness: .6pt)
#let _arrow = (end: ">", fill: luma(110))
#let _small(body) = text(size: 7.5pt, body)
#let _title(body) = text(size: 8.5pt, weight: "bold", body)

// ポアソン 方法1：時間を n 個に刻むと、事象の入った小区間の数が Bin(n, λt/n) になる
#let fig-binomial = cetz.canvas(length: .8cm, {
  import cetz.draw: *
  let events = (0.35, 1.3, 1.42, 2.6)
  let tt = 3
  let sx = 3

  // 実際の事象
  line((0, 0), (tt * sx + .4, 0), stroke: _axis, mark: _arrow)
  content((tt * sx + .55, 0), anchor: "west", _small[時間])
  content((0, -.12), anchor: "north", _small[$0$])
  content((tt * sx, -.12), anchor: "north", _small[$t$])
  line((tt * sx, 0), (tt * sx, -.08), stroke: _axis)
  for e in events { circle((e * sx, 0), radius: .08, fill: black, stroke: none) }
  content((-.3, 0), anchor: "east", _small[実際の事象])
  content((tt * sx + 1.6, 0), anchor: "west", _small[実際は$#events.len()$回])

  for (r, nn) in (6, 12, 24).enumerate() {
    let y = -1.1 - r * .9
    let w = tt / nn
    let hits = 0
    for i in range(nn) {
      let inside = events.filter(e => i * w <= e and e < (i + 1) * w).len()
      if inside > 0 { hits += 1 }
      rect(
        (i * w * sx, y - .2),
        ((i + 1) * w * sx, y + .2),
        fill: if inside > 0 { _purple.lighten(55%) } else { white },
        stroke: if inside > 1 { 1.2pt + _red } else { .4pt + luma(160) },
      )
    }
    content((-.3, y), anchor: "east", _small[$n = #nn$])
    content((tt * sx + 1.6, y), anchor: "west", _small[塗られた区間$#hits$個])
  }
  content((tt * sx / 2, -3.85), anchor: "north", text(size: 7pt, fill: _red)[赤枠：$1$つの小区間に$2$回入り、$1$回に数えられてしまう])
  content((tt * sx / 2, -4.35), anchor: "north", _small[$n -> infinity$で、塗られた区間の数（$Bin(n, lambda frac(t, n, style: "horizontal"))$）は実際の回数（$Po(lambda t)$）に一致する])
})

// ポアソン 方法2：状態 k → k+1 へ率 λ で移り、P_k(t) が順に山を作る
#let fig-pk = cetz.canvas(length: .8cm, {
  import cetz.draw: *
  let colors = (_red, _purple, _teal, rgb("#d97706"))
  // 状態遷移
  for k in range(4) {
    circle((k * 2.2, 4.4), radius: .32, fill: colors.at(k).lighten(80%), stroke: .6pt + colors.at(k))
    content((k * 2.2, 4.4), _small[$#k$])
    line((k * 2.2 + .35, 4.4), (k * 2.2 + 1.85, 4.4), stroke: .6pt, mark: (end: ">", fill: black))
    content((k * 2.2 + 1.1, 4.55), anchor: "south", _small[$lambda$])
  }
  content((4 * 2.2 + .1, 4.4), anchor: "west", _small[$dots.c$])
  content((-.5, 4.4), anchor: "east", _small[回数])

  // P_k(t) のグラフ（λ = 1）
  let sx = 1.3
  let sy = 3
  line((0, 0), (8, 0), stroke: _axis, mark: _arrow)
  line((0, 0), (0, 3.3), stroke: _axis, mark: _arrow)
  content((8.15, 0), anchor: "west", _small[$lambda t$])
  content((-.1, 3), anchor: "east", _small[$1$])
  line((0, 3), (-.08, 3), stroke: _axis)
  for k in range(4) {
    let pts = range(0, 61).map(i => {
      let x = i / 10
      (x * sx, sy * (if k == 0 { 1 } else { calc.pow(x, k) }) * calc.exp(-x) / calc.fact(k))
    })
    line(..pts, stroke: 1.2pt + colors.at(k))
    let peak = if k == 0 { (.5 * sx, sy * calc.exp(-.5)) } else { (k * sx, sy * calc.pow(k, k) * calc.exp(-k) / calc.fact(k)) }
    content((peak.at(0) + .15, peak.at(1) + .12), anchor: "south-west", text(size: 7.5pt, fill: colors.at(k))[$P_#k$])
  }
})

// 指数 方法1：A(t) = 0 の間 ⇔ まだ最初の事象が来ていない（T₁ > t）
#let fig-exp-poisson = cetz.canvas(length: .8cm, {
  import cetz.draw: *
  let arrivals = (2.4, 3.3, 4.6)
  let sx = 1.4
  let tmax = 5.6
  let u = .7
  let t1 = 1.5

  rect((0, 0), (arrivals.at(0) * sx, 2.4), fill: _red.lighten(90%), stroke: none)
  content((arrivals.at(0) * sx / 2, 2.15), text(size: 7pt, fill: _red)[$A(t) = 0$の間])

  line((0, 0), (tmax * sx + .3, 0), stroke: _axis, mark: _arrow)
  line((0, 0), (0, 2.6), stroke: _axis, mark: _arrow)
  content((tmax * sx + .45, 0), anchor: "west", _small[時間])
  content((0, 2.8), anchor: "west", _title[到着累計数$A(t)$])
  let pts = ((0, 0),)
  for (i, a) in arrivals.enumerate() {
    pts.push((a * sx, i * u))
    pts.push((a * sx, (i + 1) * u))
  }
  pts.push((tmax * sx, arrivals.len() * u))
  line(..pts, stroke: 1.2pt + _purple)

  line((t1 * sx, 0), (t1 * sx, 1.7), stroke: (paint: _red, thickness: .6pt, dash: "dashed"))
  circle((t1 * sx, 0), radius: .07, fill: _red, stroke: none)
  content((t1 * sx, -.12), anchor: "north", text(size: 7.5pt, fill: _red)[$t$])
  content((t1 * sx + .1, 1.55), anchor: "west", text(size: 7pt, fill: _red)[まだ$0$回 ⇔ $T_1 > t$])

  line((0, -.75), (arrivals.at(0) * sx, -.75), stroke: (paint: _teal, thickness: 1pt), mark: (start: "|", end: "|"))
  content((arrivals.at(0) * sx / 2, -.9), anchor: "north", text(size: 7.5pt, fill: _teal)[$T_1$（最初の事象までの時間）])

  // 右：Pr{T₁ > t} = e^{-λt}
  let bx = 9.2
  let lam = .5
  line((bx, 0), (bx + 3.6, 0), stroke: _axis, mark: _arrow)
  line((bx, 0), (bx, 2.4), stroke: _axis, mark: _arrow)
  content((bx + 3.75, 0), anchor: "west", _small[$t$])
  line(..range(0, 61).map(i => (bx + i / 10 * .6, 2 * calc.exp(-lam * i / 10))), stroke: 1.2pt + _teal)
  let py = 2 * calc.exp(-lam * t1)
  line((bx + t1 * .6, 0), (bx + t1 * .6, py), stroke: (paint: _red, thickness: .6pt, dash: "dashed"))
  line((bx, py), (bx + t1 * .6, py), stroke: (paint: _red, thickness: .6pt, dash: "dashed"))
  circle((bx + t1 * .6, py), radius: .07, fill: _red, stroke: none)
  content((bx + t1 * .6, -.12), anchor: "north", text(size: 7.5pt, fill: _red)[$t$])
  content((bx - .1, 2), anchor: "east", _small[$1$])
  content((bx + .2, 2.8), anchor: "west", _title[$Pr{T_1 > t} = Pr{A(t) = 0} = e^(-lambda t)$])
})

// 指数 方法2：刻み幅 Δt の小区間で「最初の成功」まで待つ（幾何分布）
#let fig-geometric = cetz.canvas(length: .8cm, {
  import cetz.draw: *
  let tt = 2.3
  let tmax = 3
  let sx = 3

  for (r, step) in (0.5, 0.25, 0.125).enumerate() {
    let y = -r * .9
    let kk = int(calc.floor(tt / step))
    for i in range(int(tmax / step)) {
      let success = i == kk
      let before = i < kk
      rect(
        (i * step * sx, y - .2),
        ((i + 1) * step * sx, y + .2),
        fill: if success { _teal.lighten(40%) } else if before { white } else { luma(245) },
        stroke: if before or success { .5pt + luma(120) } else { (paint: luma(200), thickness: .4pt, dash: "dotted") },
      )
    }
    content((-.3, y), anchor: "east", _small[$Delta t = #step$])
    content((tmax * sx + .3, y), anchor: "west", _small[失敗$K = #kk$個 → $K Delta t = #(kk * step)$])
  }

  let y = -2.9
  line((0, y), (tmax * sx, y), stroke: _axis, mark: _arrow)
  circle((tt * sx, y), radius: .08, fill: _teal, stroke: none)
  content((tt * sx, y - .15), anchor: "north", _small[$T = #tt$])
  content((-.3, y), anchor: "east", _small[$Delta t -> 0$])
  content((tmax * sx + .3, y), anchor: "west", _small[$K Delta t -> T$])
  content((tmax * sx / 2, -3.85), anchor: "north", _small[白：事象の起こらなかった小区間（失敗）　色：最初に起こった小区間（成功）])
})

#let document-config = (
  title: "ポアソン分布と指数分布の導出",
  description: "発生率lambdaの定義からポアソン分布と指数分布を導出し、平均・分散・モーメント母関数を求めるページ。",
  author: "Claude",
  keywords: ("統計検定", "確率分布"),
)

#show: previewer(document-config)

「単位時間あたり平均$lambda$回、ランダムに起こる」という設定だけから、ポアソン分布と指数分布を導き、平均・分散・モーメント母関数を求める。
2つの分布の関係を図で見たい場合は、#link("../probability-distributions/")[確率分布のまとめ]の「ポアソン過程」の節を参照のこと。

= 設定：ポアソン過程

#definition(title: "ポアソン過程")[
  事象が起こる時刻を早い順に$0 < S_1 < S_2 < dots.c$とし、時刻$t$までに起こった事象の個数を
  $ A(t) = \#{i >= 1 mid(|) S_i <= t} $
  で表す（$\# X$は集合$X$の要素の個数）。区間$(s, s + Delta t]$に起こる回数は$A(s + Delta t) - A(s)$である。
  また、事象と事象の間隔を$T_n = S_n - S_(n - 1)$（$S_0 = 0$）とする。

  $lambda > 0$について、次の3つを満たすとき、これを*発生率$lambda$のポアソン過程*という。

  + *独立性*：重ならない区間に起こる回数どうしは独立
  + *定常性*：$A(s + Delta t) - A(s)$の分布は$s$によらず、区間の長さ$Delta t$だけで決まる
  + *稀少性*：$Delta t -> 0$のとき
    $
      Pr{A(s + Delta t) - A(s) = 1} = lambda Delta t + o(Delta t), wide Pr{A(s + Delta t) - A(s) >= 2} = o(Delta t)
    $

  ここで$o(Delta t)$は、$Delta t -> 0$のとき$Delta t$より速く$0$に近づく量（$o(Delta t) "/" Delta t -> 0$）を表す。
]

#memo(title: [$lambda$の意味])[
  3つ目の条件は「短い時間$Delta t$の間に起こる確率は、時間の長さ$Delta t$に比例し、その比例定数が$lambda$」という意味である。
  後で示すように$EE[A(t)] = lambda t$となるので、*$lambda$は単位時間あたりの平均発生回数*（発生率）である。
  $lambda = 1$なら長さ$1$の時間に平均$1$回、長さ$T$の時間に平均$T$回起こる。
]

= ポアソン分布の導出

$P_k (t) = Pr{A(t) = k}$とおく。

== 方法1：二項分布の極限

時間$[0, t]$を$n$等分し、長さ$Delta t = t "/" n$の小区間$n$個に分ける。
$n$が十分大きければ（$Delta t$が十分小さければ）、各小区間で起こるのは高々$1$回で、その確率は稀少性から$p = lambda Delta t = lambda frac(t, n, style: "horizontal")$（発生率 × 時間の長さ）とみなせる。
独立性・定常性から各小区間は独立な同じベルヌーイ試行なので、$A(t)$は近似的に$Bin(n, lambda frac(t, n, style: "horizontal"))$に従う。

#figure(caption: [時間を$n$個に刻んで、事象の入った小区間を数える], frame(fig-binomial))

$n$が小さいと、$1$つの小区間に$2$回以上入ってしまい（赤枠）、回数を少なく数えてしまう。
しかし稀少性から、小区間に$2$回以上入る確率は$o(Delta t)$で、$n$を大きくすると無視できるようになる。

$n Delta t = t$に注意して$n -> infinity$（すなわち$Delta t -> 0$）とすると
$
  binom(n, k) p^k (1 - p)^(n - k)
  & = binom(n, k) (lambda Delta t)^k (1 - lambda Delta t)^(n - k) \
  & = frac(lambda^k, k!) dot underbrace(n Delta t dot (n - 1) Delta t dots.c (n - k + 1) Delta t, = t (t - Delta t) dots.c (t - (k - 1) Delta t)) dot (1 - lambda Delta t)^n dot (1 - lambda Delta t)^(-k) \
  & = frac(lambda^k, k!) dot underbrace(t (t - Delta t) dots.c (t - (k - 1) Delta t), -> t^k) dot underbrace((1 - lambda Delta t)^(t "/" Delta t), -> e^(-lambda t)) dot underbrace((1 - lambda Delta t)^(-k), -> 1) \
  & -> frac((lambda t)^k, k!) e^(-lambda t)
$
となる。

#memo[
  - 極限で使ったのは$(1 - lambda Delta t)^(1 "/" Delta t) -> e^(-lambda)$だけ（$(1 + x "/" n)^n -> e^x$で$x = -lambda$、$n = 1 "/" Delta t$とおいたもの）。
  - $(1 - lambda Delta t)^(t "/" Delta t)$は「長さ$t$の間、どの小区間でも起こらない確率」。後で見る#link(<exp-geometric>)[指数分布の方法2]にまったく同じ式が出てくる。
]

#theorem[
  $ Pr{A(t) = k} = frac((lambda t)^k, k!) e^(-lambda t) wide (k = 0, 1, 2, dots) $
  すなわち$A(t) tilde.op Po(lambda t)$。とくに長さ$1$の時間に起こる回数は$Po(lambda)$に従う。
]

== 方法2：微分方程式（別解）

時刻$t$から$t + Delta t$の間に何回起こるかで場合分けする。独立性と稀少性から

$
  P_0 (t + Delta t) & = P_0 (t) (1 - lambda Delta t) + o(Delta t) \
  P_k (t + Delta t) & = P_k (t) (1 - lambda Delta t) + P_(k - 1) (t) lambda Delta t + o(Delta t) wide (k >= 1)
$

移項して$Delta t$で割り、$Delta t -> 0$とすると
$
  P'_0 (t) = -lambda P_0 (t), wide P'_k (t) = -lambda P_k (t) + lambda P_(k - 1) (t)
$
を得る。初期条件は$P_0 (0) = 1$、$P_k (0) = 0$（$k >= 1$）。

1つ目から$P_0 (t) = e^(-lambda t)$。
2つ目は$Q_k (t) = e^(lambda t) P_k (t)$とおくと$Q'_k = lambda Q_(k - 1)$、$Q_0 = 1$、$Q_k (0) = 0$となり、順に積分して
$ Q_k (t) = frac((lambda t)^k, k!) quad ==> quad P_k (t) = frac((lambda t)^k, k!) e^(-lambda t) $
と、方法1と同じ結果が得られる。

#figure(caption: [回数は$0 -> 1 -> 2 -> dots.c$と率$lambda$で増えていき、$P_k (t)$の山が順に右へ移る], frame(fig-pk))

微分方程式$P'_k = -lambda P_k + lambda P_(k - 1)$は、「$k$回の状態から率$lambda$で出ていき（$-lambda P_k$）、$k - 1$回の状態から率$lambda$で入ってくる（$+lambda P_(k - 1)$）」という流れを表している。
最初は全員が$0$回（$P_0 (0) = 1$）にいて、時間とともに$1$回、$2$回、…へと移っていく。

= 指数分布の導出

最初の事象が起こるまでの時間$T = S_1$（$= T_1$）の分布を求める。

== 方法1：ポアソン分布から

「時刻$t$までに1回も起こらない」ことと「最初の事象が時刻$t$より後」であることは同じ出来事なので
$ Pr{T > t} = Pr{A(t) = 0} = e^(-lambda t) $
である。したがって分布関数と確率密度関数は
$
  F(t) = 1 - e^(-lambda t), wide f(t) = F'(t) = lambda e^(-lambda t) wide (t >= 0)
$

#figure(caption: [「時刻$t$でまだ$0$回」と「最初の事象までの時間$T_1$が$t$より長い」は同じこと], frame(fig-exp-poisson))

左のグラフで、累計回数$A(t)$が$0$のままの区間（赤）の長さが、ちょうど最初の事象までの時間$T_1$である。
時刻$t$がこの区間に入っていること（$A(t) = 0$）と、$T_1 > t$であることは同じなので、両者の確率は等しい。

== 方法2：幾何分布の極限 <exp-geometric>

ポアソン分布を経由せず、ポアソン分布の方法1と同じく*時間を細かく刻む*ことでも導ける。

時間を長さ$Delta t$の小区間に区切る。
$Delta t$が十分小さければ、各小区間で起こるのは高々$1$回で、その確率は稀少性から$p = lambda Delta t$（発生率 × 時間の長さ）とみなせる。
独立性・定常性から、各小区間は成功確率$p = lambda Delta t$の独立なベルヌーイ試行の繰り返しになる。

最初に事象が起こる小区間より前に、事象が起こらなかった小区間の数を$K$とすると、$K$は幾何分布$G(lambda Delta t)$に従う。
$ Pr{K = k} = lambda Delta t (1 - lambda Delta t)^k wide (k = 0, 1, 2, dots) $
最初の事象までの時間は$T approx K Delta t$である。

#figure(caption: [刻み幅$Delta t$を小さくすると、$K Delta t$は実際の時刻$T$に近づく], frame(fig-geometric))

「時刻$t$までに起こらない」とは「最初の$t "/" Delta t$個の小区間がすべて失敗」ということなので、$Delta t -> 0$とすると
$
  Pr{T > t} = Pr{K >= t / (Delta t)} = (1 - lambda Delta t)^(t "/" Delta t) -> e^(-lambda t)
$
となり、方法1と同じ結果が得られる。ここでも$(1 + x "/" n)^n -> e^x$（$n = t "/" Delta t$、$x = -lambda t$）を使った。

平均と分散も、幾何分布の平均$(1 - p) "/" p$・分散$(1 - p) "/" p^2$から極限で求まる。
$
  EE[T] & approx Delta t EE[K] = Delta t frac(1 - lambda Delta t, lambda Delta t) = frac(1 - lambda Delta t, lambda) -> 1/lambda \
  Var[T] & approx (Delta t)^2 Var[K] = (Delta t)^2 frac(1 - lambda Delta t, (lambda Delta t)^2) = frac(1 - lambda Delta t, lambda^2) -> 1/lambda^2
$

#memo(title: "離散と連続の対応")[
  #table(
    columns: 3,
    [], [*離散（小区間の個数）*], [*連続（時間）*],
    [起こりやすさ], [$1$つの小区間で起こる確率$p = lambda Delta t$], [発生率$lambda = p "/" Delta t$（単位時間あたりの平均回数）],
    [最初の成功まで], [幾何分布$G(p)$], [指数分布$Ex(lambda)$],
    [平均], [$(1 - p) "/" p$個], [$1 "/" lambda$],
    [無記憶性], [$Pr{K >= j + k mid(|) K >= j} = Pr{K >= k}$], [$Pr{T > s + t mid(|) T > s} = Pr{T > t}$],
  )
  指数分布は「刻み幅$Delta t -> 0$の幾何分布」。無記憶性もそのまま引き継がれる。
  ポアソン分布が「刻み幅$Delta t -> 0$の二項分布」であることと、ちょうど対になっている。
]

#theorem[
  最初の事象までの時間$T$は指数分布$Ex(lambda)$に従う。
  独立性・定常性から、ある事象から次の事象までの間隔$T_1, T_2, dots$も、互いに独立にそれぞれ$Ex(lambda)$に従う。
]

#theorem(title: "無記憶性")[
  $s, t >= 0$について
  $
    Pr{T > s + t mid(|) T > s} = frac(Pr{T > s + t}, Pr{T > s}) = frac(e^(-lambda (s + t)), e^(-lambda s)) = e^(-lambda t) = Pr{T > t}
  $
]

すでに$s$だけ待っていても、そこから先の待ち時間の分布は最初と変わらない。
これはポアソン過程の独立性・定常性（過去に何が起きたかが未来に影響しない）を、時間の側から言い換えたものである。

== 発展：$n$回目までの時間と$Gamma$分布

$n$回目の事象が起こる時刻$S_n$は、定義から$S_n = T_1 + dots.c + T_n$である。
「$n$回目が時刻$t$までに起こる」ことと「時刻$t$までに$n$回以上起こる」ことは同じなので
$ Pr{S_n <= t} = Pr{A(t) >= n} = sum_(k = n)^infinity frac((lambda t)^k, k!) e^(-lambda t) $

これを$t$で微分すると、各項の微分
$
  frac(d, d t) [frac((lambda t)^k, k!) e^(-lambda t)] = lambda frac((lambda t)^(k - 1), (k - 1)!) e^(-lambda t) - lambda frac((lambda t)^k, k!) e^(-lambda t)
$
を足し合わせたときに隣どうしが打ち消し合い、最初の項だけが残る。
$
  f_(S_n) (t) = lambda frac((lambda t)^(n - 1), (n - 1)!) e^(-lambda t) = frac(lambda^n, Gamma(n)) t^(n - 1) e^(-lambda t)
$
これは$Gamma(n, lambda)$の確率密度関数であり、指数分布$Ex(lambda)$の$n$個の和が$Gamma(n, lambda)$になることが確かめられた。

#divider()

= ポアソン分布の平均・分散

$X tilde.op Po(lambda)$とする。

== 定義から直接求める

$
  EE[X] = sum_(k = 0)^infinity k frac(lambda^k, k!) e^(-lambda) = lambda sum_(k = 1)^infinity frac(lambda^(k - 1), (k - 1)!) e^(-lambda) = lambda
$
（最後の和は$Po(lambda)$の確率の総和なので$1$。）

分散は$EE[X^2]$より$EE[X (X - 1)]$のほうが計算しやすい。
$
  EE[X (X - 1)] = sum_(k = 2)^infinity k (k - 1) frac(lambda^k, k!) e^(-lambda) = lambda^2 sum_(k = 2)^infinity frac(lambda^(k - 2), (k - 2)!) e^(-lambda) = lambda^2
$
よって
$
  Var[X] = EE[X (X - 1)] + EE[X] - (EE[X])^2 = lambda^2 + lambda - lambda^2 = lambda
$

#memo[
  階乗を含む分布では、$EE[X^2]$ではなく*$EE[X (X - 1)]$（階乗モーメント）*を計算すると、$k (k - 1)$が$k!$と約分できて楽になる。二項分布でも同じ手が使える。
]

== モーメント母関数から求める

#theorem[
  $ M_X (theta) = EE[e^(theta X)] = exp(lambda (e^theta - 1)) $
]

$
  M_X (theta) = sum_(k = 0)^infinity e^(theta k) frac(lambda^k, k!) e^(-lambda) = e^(-lambda) sum_(k = 0)^infinity frac((lambda e^theta)^k, k!) = e^(-lambda) e^(lambda e^theta)
$

微分すると
$
  M'_X (theta) = lambda e^theta M_X (theta), wide M''_X (theta) = (lambda e^theta + (lambda e^theta)^2) M_X (theta)
$
なので、$theta = 0$を代入して
$
  EE[X] = M'_X (0) = lambda, wide EE[X^2] = M''_X (0) = lambda + lambda^2, wide Var[X] = lambda
$

#theorem(title: "再生性")[
  独立に$X_1 tilde.op Po(lambda_1)$、$X_2 tilde.op Po(lambda_2)$なら
  $
    M_(X_1 + X_2) (theta) = M_(X_1) (theta) M_(X_2) (theta) = exp((lambda_1 + lambda_2)(e^theta - 1))
  $
  より$X_1 + X_2 tilde.op Po(lambda_1 + lambda_2)$。
]

これは「時間$s$の回数と、それに続く時間$t$の回数を合わせると、時間$s + t$の回数になる」（$Po(lambda s)$と$Po(lambda t)$の和が$Po(lambda (s + t))$）というポアソン過程の性質と対応している。

= 指数分布の平均・分散

$T tilde.op Ex(lambda)$とする。

== 定義から直接求める

#link("../sampling-distributions/")[$Gamma$関数]の性質$integral_0^infinity t^n e^(-lambda t) d t = frac(n!, lambda^(n + 1))$を使うと
$
  EE[T] & = integral_0^infinity t dot lambda e^(-lambda t) d t = lambda dot frac(1!, lambda^2) = 1/lambda \
  EE[T^2] & = integral_0^infinity t^2 dot lambda e^(-lambda t) d t = lambda dot frac(2!, lambda^3) = 2/lambda^2
$
よって
$ Var[T] = 2/lambda^2 - (1/lambda)^2 = 1/lambda^2 $

== モーメント母関数から求める

#theorem[
  $theta < lambda$について
  $ M_T (theta) = EE[e^(theta T)] = frac(lambda, lambda - theta) $
]

$
  M_T (theta) = integral_0^infinity e^(theta t) lambda e^(-lambda t) d t = lambda integral_0^infinity e^(-(lambda - theta) t) d t = frac(lambda, lambda - theta)
$
（$theta < lambda$でないと積分が発散する。）

これを等比級数として展開すると
$
  M_T (theta) = frac(1, 1 - theta "/" lambda) = sum_(k = 0)^infinity (theta / lambda)^k = sum_(k = 0)^infinity frac(k!, lambda^k) dot frac(theta^k, k!)
$
モーメント母関数の展開$M_T (theta) = sum_k EE[T^k] frac(theta^k, k!)$と係数を比べて
$
  EE[T^k] = frac(k!, lambda^k) quad ==> quad EE[T] = 1/lambda, wide EE[T^2] = 2/lambda^2, wide Var[T] = 1/lambda^2
$

#memo[
  - 独立な$Ex(lambda)$を$n$個足すと、モーメント母関数は$(frac(lambda, lambda - theta))^n$。これは$Gamma(n, lambda)$のモーメント母関数そのもの（#link("../../sampling-distribution/")[標本分布]の$Gamma$分布の節を参照）。
  - 上の「$n$回目までの時間」の計算と、同じ結論が別の道筋から得られる。
]

= まとめ

#table(
  columns: 5,
  [*分布*], [*意味*], [*平均*], [*分散*], [*モーメント母関数*],
  [$Po(lambda)$], [単位時間の回数], [$lambda$], [$lambda$], [$exp(lambda (e^theta - 1))$],
  [$Ex(lambda)$], [次の発生までの時間], [$1/lambda$], [$1/lambda^2$], [$frac(lambda, lambda - theta)$],
  [$Gamma(n, lambda)$], [$n$回目までの時間], [$n/lambda$], [$n/lambda^2$], [$(frac(lambda, lambda - theta))^n$],
)

#memo[
  - *$lambda$は「単位時間あたりの平均回数」*。だから回数の平均は$lambda$、間隔の平均はその逆数$1/lambda$。
  - ポアソン分布は*平均＝分散*。指数分布は*平均＝標準偏差*。
  - 2つをつなぐ式は$Pr{A(t) = 0} = e^(-lambda t) = Pr{T > t}$の1本だけ。ここから全部が出てくる。
]
