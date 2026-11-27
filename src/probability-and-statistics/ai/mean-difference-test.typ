#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "母平均の差の検定",
  description: "2つの正規母集団の母平均の差に関する検定（分散既知・等分散・ウェルチ・対応あり）をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "仮説検定"),
)

#show: previewer(document-config)

2つの正規母集団$N(mu_1, sigma_1^2)$、$N(mu_2, sigma_2^2)$から、それぞれ大きさ$m$、$n$の独立な標本$X_1, dots, X_m$と$Y_1, dots, Y_n$をとる。
標本平均を$overline(X)$、$overline(Y)$、不偏分散を$U_1^2$、$U_2^2$とし、
$ H_0 : mu_1 = mu_2 $
を検定する。

使う統計量は、*母分散について何がわかっているか*で3通りに分かれる。

#memo(title: "場合分け")[
  + 母分散$sigma_1^2, sigma_2^2$が*既知* → $Z$検定
  + 母分散は未知だが*等しい*（$sigma_1^2 = sigma_2^2$） → プールした分散による$t$検定
  + 母分散は未知で*等しいとは限らない* → ウェルチの$t$検定

  どれも形は$frac(overline(X) - overline(Y), "標準誤差")$で、分母の作り方だけが違う。
]

棄却域はいずれも、統計量を$S$、その分布の上側点を$c(alpha)$として

/ 両側検定: $abs(S) > c(alpha/2) ==> mu_1 != mu_2$
/ 右側検定: $S > c(alpha) ==> mu_1 > mu_2$
/ 左側検定: $S < -c(alpha) ==> mu_1 < mu_2$

の形になる。

= 母分散が既知のとき

#theorem[
  $H_0 : mu_1 = mu_2$のもとで
  $ Z = frac(overline(X) - overline(Y), sqrt(sigma_1^2 "/" m + sigma_2^2 "/" n)) tilde.op N(0, 1) $
]

$overline(X) - overline(Y)$は正規分布の再生性から$N(mu_1 - mu_2, sigma_1^2 "/" m + sigma_2^2 "/" n)$に従う。
独立な確率変数の差の分散は*分散の和*となる点に注意。

= 母分散が未知で等しいとき

共通の母分散$sigma^2$を、2つの標本をまとめて推定する。

#definition(title: "プールした分散")[
  $ U^2 = frac((m - 1) U_1^2 + (n - 1) U_2^2, m + n - 2) $
]

#theorem[
  $sigma_1^2 = sigma_2^2$かつ$H_0 : mu_1 = mu_2$のもとで
  $ T = frac(overline(X) - overline(Y), U sqrt(1/m + 1/n)) tilde.op t(m + n - 2) $
]

#memo[
  - $U^2$は2つの不偏分散を*自由度で重みづけした平均*。
  - 自由度は$(m - 1) + (n - 1) = m + n - 2$。各標本で平均を$1$つずつ推定したぶん、$2$減る。
]

#example[
  $m = 10$、$overline(x) = 23.0$、$u_1^2 = 4.0$と、$n = 12$、$overline(y) = 21.0$、$u_2^2 = 5.0$の2標本がある。
  母分散が等しいと仮定して、$H_0 : mu_1 = mu_2$を有意水準$5%$で両側検定せよ。
]

$ u^2 = frac(9 times 4.0 + 11 times 5.0, 20) = frac(91, 20) = 4.55 $
$ t = frac(23.0 - 21.0, sqrt(4.55) sqrt(1/10 + 1/12)) approx frac(2.0, 2.133 times 0.428) approx 2.19 $

$t_(20)(0.025) approx 2.086$で、$2.19 > 2.086$なので$H_0$を棄却する（$p approx 0.041$）。

= 母分散が未知で等しいとは限らないとき（ウェルチの検定）

#theorem[
  $H_0 : mu_1 = mu_2$のもとで、近似的に
  $ T = frac(overline(X) - overline(Y), sqrt(U_1^2 "/" m + U_2^2 "/" n)) tilde.op t(k) $
  ここで$k$は次の$c$に最も近い整数である。
  $ c = frac((U_1^2 "/" m + U_2^2 "/" n)^2, frac((U_1^2 "/" m)^2, m - 1) + frac((U_2^2 "/" n)^2, n - 1)) $
]

#memo[
  - 分子・分母は「分散既知の$Z$検定」の$sigma^2$を$U^2$に置き換えただけ。
  - 自由度$c$の式は覚えにくいが、試験では「与えられた式に代入する」形で出ることが多い。
    $c$は$min(m, n) - 1$以上$m + n - 2$以下に収まる。
  - 実務では、等分散かどうかわからないときはウェルチの検定を使うのが一般的。
]

上の例題のデータにウェルチの検定を使うと、
$ t = frac(2.0, sqrt(4.0 "/" 10 + 5.0 "/" 12)) approx frac(2.0, 0.904) approx 2.21, wide c approx 19.87 $
より自由度$20$の$t$分布を使い、$2.21 > 2.086$なので$H_0$を棄却する。

= 対応のある2標本

同じ人の「薬の投与前と投与後」のように、2つの標本が*ペアになっている*場合は、ペアごとの差$D_i = X_i - Y_i$（$i = 1, dots, n$）をとり、1標本の#link("../mean-test/")[母平均の検定]に帰着させる。

#theorem[
  差$D_i$が正規分布$N(mu_D, sigma_D^2)$に従うとき、$H_0 : mu_D = 0$のもとで
  $ T = frac(overline(D), U_D "/" sqrt(n)) tilde.op t(n - 1) $
  ここで$overline(D)$、$U_D^2$は差$D_i$の標本平均と不偏分散。
]

#example[
  $9$人について投与前後の値の差をとったところ、$overline(d) = 1.5$、$u_D = 2.0$だった。
  効果があるか（$H_1 : mu_D > 0$）、有意水準$5%$で検定せよ。
]

$ t = frac(1.5, 2.0 "/" sqrt(9)) = 2.25 $

$t_8 (0.05) approx 1.860$で、$2.25 > 1.860$なので$H_0$を棄却し、効果があると判断する。

#caution[
  対応のあるデータを、対応のない2標本として検定してはいけない。
  個人差が分散に含まれてしまい、検出力が大きく下がる。
  「同じ対象を2回測っているか」を必ず確認すること。
]

#link("../variance-ratio-test/")[母分散の比の検定]（等分散かどうかの確認）、#link("../../sampling-distribution/")[標本分布]（2標本問題の導出）も参照。
