#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "母分散の検定",
  description: "1つの正規母集団の母分散に関するchi^2検定をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "仮説検定"),
)

#show: previewer(document-config)

正規母集団$N(mu, sigma^2)$（$mu$も未知）から大きさ$n$の無作為標本をとり、母分散$sigma^2$について
$ H_0 : sigma^2 = sigma_0^2 $
を検定する。

= 検定統計量

#theorem[
  $H_0 : sigma^2 = sigma_0^2$のもとで
  $ chi^2 = frac((n - 1) U^2, sigma_0^2) = frac(sum_(i = 1)^n (X_i - overline(X))^2, sigma_0^2) tilde.op chi^2(n - 1) $
]

有意水準$alpha$の棄却域は次のとおり。

/ 両側検定: $chi^2 < chi^2_(n - 1) (1 - alpha/2)$または$chi^2 > chi^2_(n - 1) (alpha/2) ==> sigma^2 != sigma_0^2$
/ 右側検定: $chi^2 > chi^2_(n - 1) (alpha) ==> sigma^2 > sigma_0^2$
/ 左側検定: $chi^2 < chi^2_(n - 1) (1 - alpha) ==> sigma^2 < sigma_0^2$

#memo[
  - 分子は*偏差平方和*$sum (X_i - overline(X))^2 = (n - 1) U^2$。これを仮説の分散$sigma_0^2$で割る。
  - $H_0$が正しければ$U^2 approx sigma_0^2$なので、$chi^2$はだいたい自由度$n - 1$（$chi^2$分布の平均）くらいになる。
    それより極端に大きい・小さいと$H_0$が疑わしい。
  - $chi^2$分布は左右非対称なので、両側検定の下側の点は$chi^2_(n - 1) (1 - alpha/2)$を*分布表から別に読む*（$t$分布のようにマイナスをつけるだけでは求まらない）。
]

#example[
  正規母集団から$n = 10$の標本をとったところ、不偏分散が$u^2 = 2.5$だった。
  $H_0 : sigma^2 = 1.5$、$H_1 : sigma^2 > 1.5$を有意水準$5%$で検定せよ。
]

$ chi^2 = frac(9 times 2.5, 1.5) = 15.0 $

自由度$9$の上側$5%$点は$chi^2_9 (0.05) approx 16.92$で、$15.0 < 16.92$なので$H_0$を棄却しない（$p approx 0.091$）。

なお両側検定（有意水準$5%$）なら、棄却域は$chi^2 < chi^2_9 (0.975) approx 2.70$または$chi^2 > chi^2_9 (0.025) approx 19.02$である。

#caution[
  - 母平均$mu$が*既知*の場合は、$overline(X)$の代わりに$mu$を使って$sum (X_i - mu)^2 "/" sigma_0^2 tilde.op chi^2(n)$となり、自由度は$n$になる。
  - この検定は母集団が正規分布であることに強く依存する。正規分布から外れていると結果が大きく狂うので注意。
]

#link("../variance-ratio-test/")[母分散の比の検定]、#link("../sampling-distributions/")[標本分布のまとめ]も参照。
