#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "不偏分散",
  description: "不偏分散を導出しよう。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let Var = math.op("Var")

#title()
#author()

= 標本分散の非不偏性

いま母平均$mu$、母分散$sigma^2$の分布から抽出した標本の分散$S^2$は
$
  S^2 & = 1/n sum_(i = 1)^n (x_i - overline(x))^2 \
      & = 1/n sum_(i = 1)^n [(x_i - mu) - (overline(x) - mu)]^2 \
      & = 1/n sum_(i = 1)^n (x_i - mu)^2 - 2/n (overline(x) - mu) sum_(i = 1)^n (x_i - mu) + (overline(x) - mu)^2 \
      & = 1/n sum_(i = 1)^n (x_i - mu)^2 - underbracket((overline(x) - mu)^2)
$
であるから、期待値の線形性より
$
  EE[S^2] & = 1/n sum_(i = 1)^n EE[(x_i - mu)^2] - underbracket(EE[(overline(x) - mu)^2]) \
          & = 1/n Var[x_i] - Var[overline(x)] \
          & = 1/n n sigma^2 - sigma^2/n \
          & = frac(n - 1, n) sigma^2
$
となる。
すなわち、$(overline(x) - mu)^2$のために標本分散$S^2$は母分散$sigma^2$の不偏推定量ではない。

= 不偏分散

上の式と期待値の線形性より
$
  EE[frac(n, n - 1) S^2] = sigma^2
$
がいえて、この
$
  U^2 = frac(n, n - 1) S^2 = frac(1, n - 1) sum_(i = 1)^n (x_i - overline(x))^2
$
を*不偏分散*という。

= 不偏分散の一致性

不偏分散$U^2$は母分散$sigma^2$の一致推定量である。

まず、大数の法則より
$
  overline(x) = 1/n sum_(i = 1)^n x_i -->_P mu, wide overline(x^2) = 1/n sum_(i = 1)^n x_i^2 -->_P mu^2 + sigma^2
$
であるから
$
  S^2 = overline(x^2) - (overline(x))^2 -->_P (mu^2 + sigma^2) - mu^2 = sigma^2
$
とわかる。

よって
$
  U^2 = frac(n, n - 1) S^2 -->_P sigma^2
$
であり、ゆえに不偏分散$U^2$は母分散$sigma^2$の一致推定量である。

一方で、不偏分散は母分散の有効推定量ではないことが知られている。
