#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "回帰係数の検定",
  description: "単回帰・重回帰における回帰係数のt検定と、回帰式全体のF検定をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "仮説検定", "回帰分析"),
)

#show: previewer(document-config)

回帰分析で得られた係数が「本当に$0$でないか」（説明変数が目的変数の説明に役立っているか）を調べる。
推定量の分布や信頼区間は#link("../regression-estimation/")[回帰係数の推定]にまとめてある。

= 単回帰の傾きの検定

#definition(title: "単回帰モデル")[
  $ Y_i = beta_0 + beta_1 x_i + epsilon_i, wide epsilon_i tilde.op N(0, sigma^2) "（独立）" quad (i = 1, dots, n) $
]

#link("../../least-squares-method/")[最小二乗法]による推定値は
$ hat(beta)_1 = S_(x y) / S_(x x), wide hat(beta)_0 = overline(y) - hat(beta)_1 overline(x) $
ここで$S_(x x) = sum (x_i - overline(x))^2$、$S_(x y) = sum (x_i - overline(x))(y_i - overline(y))$である。

残差$e_i = y_i - (hat(beta)_0 + hat(beta)_1 x_i)$を使って、誤差分散$sigma^2$を
$ s^2 = frac(sum e_i^2, n - 2) $
で推定する。

#theorem[
  $H_0 : beta_1 = 0$のもとで
  $ T = frac(hat(beta)_1, se(hat(beta)_1)) tilde.op t(n - 2), wide se(hat(beta)_1) = frac(s, sqrt(S_(x x))) $
]

有意水準$alpha$の両側検定では$abs(T) > t_(n - 2) (alpha/2)$なら$H_0$を棄却し、「$x$は$y$の説明に有意に役立っている」と判断する。

#memo[
  - 形は「推定値 ÷ 標準誤差」。母平均の$t$検定と同じ考え方。
  - 自由度は$n - 2$。$beta_0$と$beta_1$の$2$つを推定したぶん減る。
  - $S_(x x)$が大きい（$x$が広く散らばっている）ほど標準誤差は小さく、傾きを精度よく推定できる。
]

#example[
  $n = 12$組のデータで単回帰を行ったところ、傾きの推定値が$0.8$、その標準誤差が$0.3$だった。
  $H_0 : beta_1 = 0$を有意水準$5%$で両側検定せよ。
]

$ t = 0.8 / 0.3 approx 2.67 $

自由度$12 - 2 = 10$で$t_(10)(0.025) approx 2.228$。$2.67 > 2.228$なので$H_0$を棄却する（$p approx 0.024$）。

= 自由度が大きいときの正規近似

残差の自由度$n - 2$（重回帰なら$n - p - 1$）が十分大きいとき、$t$分布は標準正規分布で近似できる。

#theorem[
  自由度が大きければ、$H_0 : beta_1 = 0$のもとで近似的に
  $ Z = frac(hat(beta)_1, se(hat(beta)_1)) tilde.op N(0, 1) $
  であり、両側検定の棄却域は$abs(Z) > z(alpha/2)$（$5%$なら$1.96$）としてよい。
]

#example[
  $n = 102$組のデータで単回帰を行ったところ、傾きの推定値が$0.5$、標準誤差が$0.2$だった。
  $H_0 : beta_1 = 0$を有意水準$5%$で両側検定せよ。
]

自由度は$100$と大きいので正規近似を用いる。
$z = 0.5 "/" 0.2 = 2.5 > 1.96$なので$H_0$を棄却する（$p approx 0.012$）。
$t(100)$を正確に使っても$t_(100)(0.025) approx 1.984$で、結論は変わらない。

#memo[
  - 自由度が$30$程度を超えたら$t approx z$。$t$分布表がなくても$1.96$（両側$5%$）、$2.576$（両側$1%$）で判断できる。
  - ソフトウェアの出力で「$abs("t value") > 2$なら大体$5%$有意」と読めるのは、この正規近似のおかげ。
  - 自由度が小さいときに正規近似を使うと、棄却域が広くなりすぎて第1種の過誤が増える。
]

= 重回帰の回帰係数の検定

説明変数が$p$個の重回帰モデル
$ Y_i = beta_0 + beta_1 x_(i 1) + dots.c + beta_p x_(i p) + epsilon_i $
では、各係数について同じ形の$t$検定を行う。

#theorem[
  $H_0 : beta_j = 0$のもとで
  $ T = frac(hat(beta)_j, se(hat(beta)_j)) tilde.op t(n - p - 1) $
]

#memo[
  - 自由度は「$n$ −（推定した係数の数）」$= n - (p + 1)$。単回帰は$p = 1$の場合。
  - 重回帰の係数$hat(beta)_j$は*偏回帰係数*。「他の説明変数を固定したときの効果」なので、単回帰の傾きとは値も符号も変わりうる。
  - 説明変数同士の相関が強い（*多重共線性*）と標準誤差が大きくなり、個々の係数が有意になりにくい。
]

= 回帰式全体の$F$検定

「説明変数がどれも役に立っていない」かどうかを、まとめて検定する。

#theorem[
  $H_0 : beta_1 = beta_2 = dots.c = beta_p = 0$のもとで
  $ F = frac(S_R "/" p, S_e "/" (n - p - 1)) tilde.op F(p, n - p - 1) $
  ここで$S_R = sum (hat(y)_i - overline(y))^2$は回帰平方和、$S_e = sum e_i^2$は残差平方和。
]

$F > F^p_(n - p - 1) (alpha)$なら$H_0$を棄却する（右側検定）。

決定係数$R^2 = S_R "/" (S_R + S_e)$を使うと
$ F = frac(R^2 "/" p, (1 - R^2) "/" (n - p - 1)) $
とも書ける。

#memo[
  - 「回帰で説明できた変動」と「説明できなかった変動」を、それぞれ自由度で割ってから比べる。#link("../anova/")[分散分析]と同じ考え方。
  - 単回帰（$p = 1$）では、傾きの$t$統計量の2乗が$F$統計量に一致する（$t(n - 2)^2 = F(1, n - 2)$）。
]

= ソフトウェア出力の読み方

統計ソフトウェアの回帰分析の出力には、たいてい次の列が並ぶ。

#table(
  columns: 5,
  [], [*Estimate*], [*Std. Error*], [*t value*], [*Pr(>|t|)*],
  [(Intercept)], [$hat(beta)_0$], [$se(hat(beta)_0)$], [$hat(beta)_0 "/" se(hat(beta)_0)$], [$p$値],
  [x1], [$hat(beta)_1$], [$se(hat(beta)_1)$], [$hat(beta)_1 "/" se(hat(beta)_1)$], [$p$値],
)

#memo[
  - *t value = Estimate ÷ Std. Error*。どれか1つが空欄になっていて、それを計算させる問題が多い。
  - *Pr(>|t|)*は両側検定の$p$値。$0.05$未満なら有意水準$5%$で有意。
  - 出力の下のほうにある*F-statistic*とその$p$値が、回帰式全体の$F$検定。
]

関連：#link("../anova/")[一元配置分散分析]、#link("../hypothesis-testing/")[仮説検定の基礎]
