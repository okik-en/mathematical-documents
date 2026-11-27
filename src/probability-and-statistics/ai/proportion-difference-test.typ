#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "母比率の差の検定",
  description: "2つの母集団の母比率の差に関する検定をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "仮説検定"),
)

#show: previewer(document-config)

2つの母集団の母比率を$p_1$、$p_2$とする。
それぞれから大きさ$m$、$n$の独立な標本をとり、性質をもつものが$X$個、$Y$個だったとき、
$ H_0 : p_1 = p_2 $
を検定する。

= 検定統計量

標本比率を$hat(p)_1 = X "/" m$、$hat(p)_2 = Y "/" n$とする。
$H_0$のもとでは$p_1 = p_2 = p$なので、共通の$p$を2つの標本をまとめて推定する。

#definition(title: "プールした比率")[
  $ hat(p) = frac(X + Y, m + n) $
]

#theorem[
  $H_0 : p_1 = p_2$のもとで、$m, n$が十分大きければ近似的に
  $ Z = frac(hat(p)_1 - hat(p)_2, sqrt(hat(p) (1 - hat(p)) (1/m + 1/n))) tilde.op N(0, 1) $
]

有意水準$alpha$の棄却域は次のとおり。

/ 両側検定: $abs(Z) > z(alpha/2) ==> p_1 != p_2$
/ 右側検定: $Z > z(alpha) ==> p_1 > p_2$
/ 左側検定: $Z < -z(alpha) ==> p_1 < p_2$

#memo[
  - 独立な2つの比率の差の分散は$frac(p_1 (1 - p_1), m) + frac(p_2 (1 - p_2), n)$。
    $H_0$のもとで$p_1 = p_2 = p$とおくと$p (1 - p)(1/m + 1/n)$になり、この$p$を$hat(p)$で推定する。
  - 「検定は$H_0$のもとで計算する」ので、*プールした$hat(p)$*を使う。
    区間推定では$H_0$がないので、$hat(p)_1$、$hat(p)_2$を別々に使う。この違いはよく問われる。
]

#example[
  A地区では$200$人中$120$人、B地区では$300$人中$150$人がある政策に賛成した。
  賛成率に差があるか、有意水準$5%$で両側検定せよ。
]

$hat(p)_1 = 0.6$、$hat(p)_2 = 0.5$、$hat(p) = frac(120 + 150, 200 + 300) = 0.54$なので
$
  z = frac(0.6 - 0.5, sqrt(0.54 times 0.46 times (1/200 + 1/300))) approx frac(0.1, 0.0455) approx 2.20
$

$2.20 > 1.96$なので$H_0$を棄却し、賛成率に差があると判断する（$p approx 0.028$）。

#caution[
  2×2のクロス表で比率の差を調べる場合、この検定は#link("../independence-test/")[独立性の検定]と同じ結論になる（$Z^2$が独立性の検定の$chi^2$統計量に一致する）。
]

#link("../proportion-test/")[母比率の検定]も参照。
