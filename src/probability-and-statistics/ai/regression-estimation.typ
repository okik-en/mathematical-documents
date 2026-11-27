#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "回帰係数の推定",
  description: "回帰係数の点推定・標準誤差・信頼区間と、自由度が大きいときの正規近似をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "推定", "回帰分析"),
)

#show: previewer(document-config)

最小二乗法で求めた回帰係数は、データから計算した*推定値*であり、標本が変われば値も変わる。
このページでは、その推定値がどのくらいぶれるか（分布・標準誤差）と、信頼区間の作り方をまとめる。
導出の詳細は#link("../../least-squares-method/")[線形単回帰と最小二乗法]を参照のこと。

#caution(title: "記号について")[
  元のページでは回帰直線を$y = alpha x + beta$と書いているが、このページでは有意水準の$alpha$と区別するため
  $ y = beta_0 + beta_1 x $
  と書く。元のページの$alpha$（傾き）が$beta_1$、$beta$（切片）が$beta_0$に対応する。
]

= モデルと推定量

#definition(title: "単回帰モデル")[
  $ Y_i = beta_0 + beta_1 x_i + epsilon_i, wide epsilon_i tilde.op N(0, sigma^2) "（独立）" quad (i = 1, dots, n) $
  $x_i$は確率変数ではなく、与えられた値とみなす。
]

$S_(x x) = sum (x_i - overline(x))^2$、$S_(x y) = sum (x_i - overline(x))(y_i - overline(y))$とおくと、最小二乗推定量は
$ hat(beta)_1 = S_(x y) / S_(x x), wide hat(beta)_0 = overline(y) - hat(beta)_1 overline(x) $
である。

= 推定量の分布

#theorem[
  + $hat(beta)_1$、$hat(beta)_0$はそれぞれ$beta_1$、$beta_0$の*不偏推定量*である。
  + 分散は
    $ Var[hat(beta)_1] = frac(sigma^2, S_(x x)), wide Var[hat(beta)_0] = sigma^2 (1/n + frac(overline(x)^2, S_(x x))) $
  + $hat(beta)_1$、$hat(beta)_0$は正規分布に従う。
]

$hat(beta)_1$が$Y_i$（したがって$epsilon_i$）の*1次式*で書けることから、正規分布の再生性によって正規分布に従う。

#memo[
  - $hat(beta)_1$の分散は$frac(sigma^2, S_(x x))$。
    *誤差が小さい*（$sigma$が小さい）ほど、*$x$が広く散らばっている*（$S_(x x)$が大きい）ほど、傾きは安定する。
    実験で$x$を選べるなら、なるべく広い範囲にとるとよい。
  - $hat(beta)_0$の分散は、$overline(x)$が$0$から遠いほど大きい。
    切片は$x = 0$での値なので、データの中心から遠いところへ延長するほど不確かになる。
]

= 誤差分散の推定と標準誤差

$sigma^2$は未知なので、残差$e_i = y_i - hat(y)_i$から推定する。

#theorem[
  $ s^2 = frac(1, n - 2) sum_(i = 1)^n e_i^2 $
  は$sigma^2$の不偏推定量であり、$frac((n - 2) s^2, sigma^2) tilde.op chi^2(n - 2)$。
  また$s^2$は$hat(beta)_0$、$hat(beta)_1$と独立である。
]

#memo[
  $n - 2$で割るのは、$beta_0$と$beta_1$の*2つのパラメータを推定した*から。
  標本分散を$n - 1$で割るのと同じ理由（推定したパラメータの数だけ自由度が減る）。
]

#definition(title: "標準誤差")[
  分散の式の$sigma$を$s$で置き換えたものを*標準誤差*という。
  $ se(hat(beta)_1) = frac(s, sqrt(S_(x x))), wide se(hat(beta)_0) = s sqrt(1/n + frac(overline(x)^2, S_(x x))) $
]

#theorem[
  $ T = frac(hat(beta)_1 - beta_1, se(hat(beta)_1)) tilde.op t(n - 2) $
  （$hat(beta)_0$についても同様。）
]

これは、母平均の推定で$frac(overline(X) - mu, U "/" sqrt(n)) tilde.op t(n - 1)$となるのとまったく同じ構造である。

= 信頼区間

#theorem[
  $beta_1$の$100(1 - alpha)%$信頼区間は
  $ hat(beta)_1 - t_(n - 2) (alpha/2) se(hat(beta)_1) <= beta_1 <= hat(beta)_1 + t_(n - 2) (alpha/2) se(hat(beta)_1) $
]

#memo[
  *「推定値 ± $t$の点 × 標準誤差」*。どの信頼区間もこの形。
]

#example[
  $n = 12$組のデータで単回帰したところ、$hat(beta)_1 = 0.8$、$se(hat(beta)_1) = 0.3$だった。
  $beta_1$の$95%$信頼区間を求めよ。
]

自由度$10$で$t_(10)(0.025) approx 2.228$なので
$ 0.8 plus.minus 2.228 times 0.3 = 0.8 plus.minus 0.668 $
より、$95%$信頼区間は$[0.132, 1.468]$。

この区間は$0$を含まないので、有意水準$5%$の両側検定で$H_0 : beta_1 = 0$は棄却される（#link("../regression-test/")[回帰係数の検定]を参照）。

= 自由度が大きいときの正規近似

$t$分布は自由度が大きくなると標準正規分布に近づく。
そのため、*残差の自由度$n - 2$（重回帰なら$n - p - 1$）が十分大きい*ときは、$t$分布の点の代わりに正規分布の点を使ってよい。

#theorem[
  自由度$nu -> infinity$のとき$t(nu) -> N(0, 1)$。したがって$nu$が大きければ近似的に
  $ frac(hat(beta)_1 - beta_1, se(hat(beta)_1)) tilde.op N(0, 1) $
  であり、$95%$信頼区間は
  $ hat(beta)_1 plus.minus 1.96 se(hat(beta)_1) $
  で近似できる。
]

$t$分布の上側点が$z$の値にどのくらい近づくかを見ると、次のとおり。

#table(
  columns: 3,
  [*自由度*], [*$t(0.025)$*], [*$t(0.05)$*],
  [$5$], [$2.571$], [$2.015$],
  [$10$], [$2.228$], [$1.812$],
  [$20$], [$2.086$], [$1.725$],
  [$30$], [$2.042$], [$1.697$],
  [$60$], [$2.000$], [$1.671$],
  [$120$], [$1.980$], [$1.658$],
  [$infinity$（正規分布）], [$1.960$], [$1.645$],
)

#example[
  $n = 102$組のデータで単回帰したところ、$hat(beta)_1 = 0.5$、$se(hat(beta)_1) = 0.2$だった。
  正規近似を用いて$beta_1$の$95%$信頼区間を求め、$H_0 : beta_1 = 0$を有意水準$5%$で両側検定せよ。
]

自由度は$100$と大きいので正規近似を用いる。
$ 0.5 plus.minus 1.96 times 0.2 = 0.5 plus.minus 0.392 $
より、$95%$信頼区間は$[0.108, 0.892]$。

検定統計量は$z = 0.5 "/" 0.2 = 2.5 > 1.96$なので、$H_0$を棄却する（$p approx 0.012$）。

参考：$t(100)$を正確に使うと$t_(100)(0.025) approx 1.984$で、信頼区間は$[0.103, 0.897]$。ほとんど変わらない。

#memo[
  - 自由度が*$30$を超えたら*$t approx z$とみなしてよい、というのが目安（$100$以上ならほぼ確実）。
  - 正規近似を使うと、*$t$分布表を引かずに*$1.96$（両側$5%$）、$2.576$（両側$1%$）で判断できる。
  - 「$|t| > 2$なら大体$5%$有意」という経験則も、自由度が大きいときの正規近似から来ている。
  - 自由度が小さいとき（例えば$10$）に$1.96$を使うと、区間が狭くなりすぎ、有意になりやすくなる（第1種の過誤が増える）ので注意。
]

#caution[
  正規近似は誤差項$epsilon_i$が正規分布に従わない場合にも役立つ。
  $n$が大きければ、中心極限定理により$hat(beta)_1$は近似的に正規分布に従うので、$frac(hat(beta)_1 - beta_1, se(hat(beta)_1))$を$N(0, 1)$で近似できる。
]

= 重回帰の場合

説明変数が$p$個の重回帰
$ Y_i = beta_0 + beta_1 x_(i 1) + dots.c + beta_p x_(i p) + epsilon_i $
でも、同じ形が成り立つ。

#theorem[
  $ s^2 = frac(1, n - p - 1) sum e_i^2, wide frac(hat(beta)_j - beta_j, se(hat(beta)_j)) tilde.op t(n - p - 1) $
  $beta_j$の$100(1 - alpha)%$信頼区間は
  $ hat(beta)_j plus.minus t_(n - p - 1) (alpha/2) se(hat(beta)_j) $
  であり、$n - p - 1$が大きければ$t_(n - p - 1)(alpha/2)$を$z(alpha/2)$で置き換えてよい。
]

#memo[
  - 自由度は「データ数 − 推定した係数の数（切片を含めて$p + 1$個）」。
  - $se(hat(beta)_j)$は手計算せず、ソフトウェアの出力（Std. Error）を使うのが普通。
    出力の読み方は#link("../regression-test/")[回帰係数の検定]を参照。
]

#link("../regression-test/")[回帰係数の検定]、#link("../mean-test/")[母平均の検定]（同じ構造の$t$統計量）、#link("../sampling-distributions/")[標本分布のまとめ]も参照。
