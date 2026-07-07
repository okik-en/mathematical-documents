#import "@preview/cetz:0.5.2"
#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "有限母集団補正",
  description: "有限母集団補正とは何か。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let Var = math.op("Var")
#let Hyper = math.op("Hyper")
#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)

#title()
#author()

= 超幾何分布

母比率$p = M/N$の有限母集団から$n$個の標本を*非復元抽出*することを考える。

いま、二項係数を次のとおり拡張する。
$
  binom(n, k) = cs(
    frac(n!, k! (n - k)!) wide (k = 0, 1, dots, n),
    0 wide ("otherwise")
  )
$

いま、標本のうち性質を満たすものの個数を$k$とすると、場合の数は
$ binom(M, k) dot binom(N - M, n - k) $
であり、ゆえに
$
  binom(N, n) = sum_(k = 0)^n [binom(M, k) dot binom(N - M, n - k)]
$
がいえる。

しかも$k$を確率変数とみなすと、$k$は分布
$
  Pr{X = k} = frac(binom(M, k) dot binom(N - M, n - k), binom(N, n)) quad (k in 0, 1, dots, n)
$
に従う。
この分布は*超幾何分布*と呼ばれる。以降$Hyper(N, M, n)$で表す。

二項分布は復元抽出であったことに注意せよ。

= 有限母集団補正

超幾何分布に従う確率変数$X tilde.op Hyper(N, M, n)$の期待値は
$
  EE[X] & = frac(1, binom(N, n)) sum_(k = 0)^n [k binom(M, k) dot binom(N - M, n - k)] \
        & = frac(1, binom(N, n)) sum_(k = 0)^n [M binom(M - 1, k - 1) dot binom(N - M, (n - 1) - (k - 1))] \
        & = frac(1, binom(N, n)) M sum_(k' = 0)^(n - 1) [binom(M - 1, k') dot binom((N - 1) - (M - 1), (n - 1) - k')] \
        & = frac(binom(N - 1, n - 1), binom(N, n)) M = n/N M = n M/N = n p
$
と二項分布の結果に一致する。

一方で分散は二項分布の結果と一致しない。
これを示そう。

ところで、任意の確率変数$X$について
$
  Var(X) = EE[X (X - 1)] + EE[X] - (EE[X])^2
$
であることが知られている。
ここで$EE[X (X - 1)]$は*分散モーメント*と呼ばれる。

いま、$X tilde.op Hyper(N, M, n)$について
$
  EE[X (X - 1)] &= frac(1, binom(N, n)) sum_(k = 0)^n [k (k - 1) binom(M, k) dot binom(N - M, n - k)] \
  &= frac(1, binom(N, n)) sum_(k = 0)^n [M (M - 1) binom(M - 2, k - 2) dot binom((N - 2) - (M - 2), (n - 2) - (k - 2))] \
  & = frac(1, binom(N, n)) M (M - 1) sum_(k' = 0)^(n - 2) [binom(M - 2, k') dot binom((N - 2) - (M - 2), (n - 2) - k')] \
  & = frac(binom(N - 2, n - 2), binom(N, n)) M (M - 1) = frac(n (n - 1), N (N - 1)) M (M - 1)
$
であるから、その分散は
$
  Var(X) & = n (n - 1) frac(M (M - 1), N (N - 1)) + n M/N - n^2 M^2/N^2 \
         & = n M/N [frac((n - 1) (M - 1), N - 1) + 1 - n M/N] \
         & = n M/N dot frac((n M - n - M + N) N - n M (N - 1), N (N - 1)) \
         & = n M/N dot frac(- n N - M N + N^2 + n M, N (N - 1)) \
         & = n M/N dot frac((N - M) (N - n), N (N - 1)) \
         & = n M/N (1 - M/N) times frac(N - n, N - 1) \
         & = n p (1 - p) times frac(N - n, N - 1)
$
となり、二項分布の結果$n p (1 - p)$に補正係数$frac(N - n, N - 1)$が乗じられてしまう。

このように、超幾何分布を二項分布により近似するとき、（厳密には）分散に補正係数
$
  frac(N - n, N - 1)
$
を乗じなければならず、これを*有限母集団補正*という。

= 補正係数

$N - 1 approx N$として抽出率$f = n/N$と補正係数の関係を調べると
$
  frac(N - n, N - 1) approx frac(N - n, N) = 1 - n/N = 1 - f
$
となり、例えば相対誤差が$frac(f, 1 - f) = 5%$となる点は$f approx 4.76%$であるとわかる。

よっておよそ$f >= 5%$のときは有限母集団補正を考慮する必要があり、実際の運用でもこれを目安とすることが多い。
