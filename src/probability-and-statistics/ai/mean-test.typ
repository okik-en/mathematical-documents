#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "母平均の検定",
  description: "1つの正規母集団の母平均に関するZ検定とt検定をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "仮説検定"),
)

#show: previewer(document-config)

正規母集団$N(mu, sigma^2)$から大きさ$n$の無作為標本$X_1, dots, X_n$をとり、母平均$mu$について
$ H_0 : mu = mu_0 $
を検定する。

使う統計量は、*母分散$sigma^2$が既知か未知か*で変わる。

= 母分散が既知のとき（$Z$検定）

#theorem[
  $H_0 : mu = mu_0$のもとで
  $ Z = frac(overline(X) - mu_0, sigma "/" sqrt(n)) tilde.op N(0, 1) $
]

有意水準$alpha$の棄却域は次のとおり。

/ 両側検定: $abs(Z) > z(alpha/2) ==> mu != mu_0$
/ 右側検定: $Z > z(alpha) ==> mu > mu_0$
/ 左側検定: $Z < -z(alpha) ==> mu < mu_0$

#example[
  $N(mu, 5^2)$から$n = 25$の標本をとったところ、$overline(x) = 52$だった。
  $H_0 : mu = 50$、$H_1 : mu != 50$を有意水準$5%$で検定せよ。
]

$ z = frac(52 - 50, 5 "/" sqrt(25)) = 2 / 1 = 2.0 $

$abs(z) = 2.0 > 1.96 = z(0.025)$なので、$H_0$を棄却する（$p approx 0.046$）。

= 母分散が未知のとき（$t$検定）

$sigma$がわからないので、代わりに不偏分散
$ U^2 = frac(1, n - 1) sum_(i = 1)^n (X_i - overline(X))^2 $
の平方根$U$を使う。

#theorem[
  $H_0 : mu = mu_0$のもとで
  $ T = frac(overline(X) - mu_0, U "/" sqrt(n)) tilde.op t(n - 1) $
]

有意水準$alpha$の棄却域は次のとおり。

/ 両側検定: $abs(T) > t_(n - 1) (alpha/2) ==> mu != mu_0$
/ 右側検定: $T > t_(n - 1) (alpha) ==> mu > mu_0$
/ 左側検定: $T < -t_(n - 1) (alpha) ==> mu < mu_0$

#example[
  正規母集団から$n = 16$の標本をとったところ、$overline(x) = 10.6$、$u = 1.2$だった。
  $H_0 : mu = 10$を有意水準$5%$で、(a) 両側検定、(b) 右側検定せよ。
]

$ t = frac(10.6 - 10, 1.2 "/" sqrt(16)) = frac(0.6, 0.3) = 2.0 $

自由度は$n - 1 = 15$である。

+ 両側：$t_(15)(0.025) approx 2.131$で、$abs(t) = 2.0 < 2.131$なので$H_0$を棄却しない（$p approx 0.064$）。
+ 右側：$t_(15)(0.05) approx 1.753$で、$t = 2.0 > 1.753$なので$H_0$を棄却する（$p approx 0.032$）。

同じデータでも、両側か片側かで結論が変わりうることに注意。

#memo[
  - 形はどちらも$frac("標本平均" - "仮説の値", "標準誤差")$。
    分母の$sigma$を$U$に置き換えたら、$N(0, 1)$を$t(n - 1)$に置き換える。
  - 自由度が$n - 1$なのは、$U^2$の計算で$mu$の代わりに$overline(X)$を使ったから。
  - $n$が大きい（目安$n >= 30$）ときは、$sigma$が未知でも$t(n - 1) approx N(0, 1)$として$Z$検定で近似することが多い。
]

#caution[
  - 統計量で使うのは*不偏分散$U^2$*（$n - 1$で割る）。$n$で割った標本分散$S^2$が与えられた場合は$U^2 = frac(n, n - 1) S^2$に直してから使う。
  - 母集団が正規分布でない場合でも、$n$が大きければ中心極限定理により$Z$検定で近似できる。
]

= 信頼区間との関係

有意水準$alpha$の両側検定で$H_0 : mu = mu_0$が棄却されないことと、$mu_0$が$100(1 - alpha)%$信頼区間
$ overline(X) - t_(n - 1) (alpha/2) U/sqrt(n) <= mu <= overline(X) + t_(n - 1) (alpha/2) U/sqrt(n) $
に含まれることは同値である。

#memo[
  「信頼区間に入っていれば棄却しない、外れていれば棄却する」。
  区間推定の問題と検定の問題は、同じ式の裏表である（#link("../../confidence-interval/")[信頼区間]も参照）。
]

#link("../hypothesis-testing/")[仮説検定の基礎]、#link("../mean-difference-test/")[母平均の差の検定]も参照。
