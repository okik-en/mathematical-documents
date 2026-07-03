#import "@preview/cetz:0.5.2"
#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "信頼区間",
  description: "信頼区間を導出するページ。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)

#let ip(a, b) = $lr(chevron.l #a, #b chevron.r)$

#title()
#author()

#outline()

確率変数$X tilde.op N(mu, sigma^2)$を用意する（$sigma > 0$とする）。
$X$の$100(1 - alpha)%$両側信頼区間を求めよう。

= 標準化変数

いま、$Z = a X + b$で、かつ$Z tilde.op N(0, 1)$と仮定する（正規分布の再生性よりそのような$Z$が存在する）。

このとき、期待値および分散の性質より
$
  0 = EE[Z] = EE[a X + b] = a EE[X] + b = a mu + b \
  1 = VV[Z] = VV[a X + b] = a^2 VV[X] = a^2 sigma^2
$
がいえる。

後者より：
$ a = 1/sigma $

また前者より：
$ b = - a mu = - mu/sigma $

ゆえにそのような$Z tilde.op N(0, 1)$は
$
  Z = frac(X - mu, sigma)
$
と表せて、これを$X$の*標準化変数*と呼ぶ。

= 信頼区間の導出

いま、$Z tilde.op N(0, 1)$の上側$100beta%$点を$z(beta)$とする。
すなわち：
$ Pr{Z >= z(beta)} = beta $

#figure(
  caption: [上側$100beta%$点],
  frame-it(cetz.canvas({
    import cetz.draw: *
    let pts = range(-100, 100, inclusive: true).map(x => (x / 20, calc.pi * calc.exp(-x * x / 2000)))
    line(..pts)
    line(pts.at(100 + 40), (40 / 20, 0))
    content((2.4, .4), $beta$)
    content((40 / 20, 0), anchor: "north", box(inset: 2pt, $z(beta)$))
  })),
)

このとき、$abs(Z) >= z(beta)$となる確率は、正規分布の対称性より
$ Pr{abs(Z) >= z(beta)} = Pr{Z >= z(beta)} + Pr{Z <= -z(beta)} = 2 Pr{Z >= z(beta)} = 2 beta $
であるから、$2 beta = alpha$とすれば
$ Pr{abs(Z) >= z(alpha/2)} = 100alpha% $
すなわち
$ Pr{abs(Z) <= z(alpha/2)} = 100(1 - alpha)% $
が成り立つ。

先程$Z = frac(X - mu, sigma)$であったから、これは
$
       & frac(abs(X - mu), sigma) <= z(alpha/2) \
  <==> & abs(X - mu) <= z(alpha/2) sigma \
  <==> & X - mu >= - z(alpha/2) sigma or X - mu <= z(alpha/2) sigma \
  <==> & X in [mu - z(alpha/2) sigma, mu + z(alpha/2) sigma]
$
であり、ゆえに
$
  Pr{X in [mu - z(alpha/2) sigma, mu + z(alpha/2) sigma]} = 100(1 - alpha)%
$
がいえる。

すなわち、$X$の$100(1 - alpha)%$両側信頼区間は
$
  [mu - z(alpha/2) sigma, mu + z(alpha/2) sigma]
$
と求まる。
