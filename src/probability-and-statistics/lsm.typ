#import "/lib/utils.typ": *

#let document-config = (
  title: "最小二乗法",
  description: "最小二乗法はどのようにして導出されるのか。",
  author: "Salty Lemon",
)

#show: previewer(document-config)

= 単回帰

相関とは、2変量$(x, y)$の間の間にある関係のことを指す。
相関に対して、説明変数$x$から目的変数$y$の予測を目指すことを単回帰という。

例えば一次関数による単回帰を考える。目的変数$y$が説明変数$x$の一次関数であると主張したいものとする。

$ hat(y_i) = alpha x_i + beta $

しかしこのとき、実際には誤差$epsilon$が発生し、これを*残差*と呼ぶ。

$ y_i = alpha x_i + beta + epsilon_i thick (= hat(y_i) + epsilon_i) $

よりよい説明のためには、残差が最小であることが望ましい。その基準として残差の分散$sigma_epsilon^2$を最小化することが考えられる。

$ sigma_epsilon^2 = 1/n sum_i epsilon_i^2 = 1/n sum_i (y_i - hat(y_i))^2 = 1/n sum_i (alpha x_i + beta - y_i)^2 $

これを*最小二乗法*またはLSM(Least Squares Method)という。
（注：厳密には、残差の分散ではなく*残差平方和*$sum_i epsilon_i^2$を最小化するものであるが、標本数$n$を固定した場合これらは同一視できる。）

== 最小二乗法による最適化

残差の分散を$alpha$および$beta$について整理すると
$
  sigma_epsilon^2 & = 1/n sum_i (x_i alpha + beta - y_i)^2 \
  & = 1/n sum_i (x_i^2 alpha^2 + 2 x_i alpha beta + beta^2 - 2 x_i y_i alpha - 2 y_i beta + y_i^2) \
  & = (1/n sum_i x_i^2) alpha^2 + 2 (1/n sum_i x_i) alpha beta + beta^2 - 2 (1/n sum_i x_i y_i) alpha - 2 (1/n sum_i y_i) beta + (1/n sum_i y_i^2) \
  & = (sigma_x^2 + (overline(x))^2) alpha^2 + 2 overline(x) alpha beta + beta^2 - 2 (sigma_(x y) + overline(x) thin overline(y)) alpha - 2 overline(y) beta + sigma_y^2 + (overline(y))^2
$
となる。

ここで$alpha$と$beta$を変数とみれば、$sigma_epsilon^2$は二次式であり、しかも$alpha^2$および$beta^2$の係数は正であるため、$sigma_epsilon^2$は凸関数である。

すなわち$sigma_epsilon^2$は
#eqref(<partial>)[$
  frac(partial, partial alpha) sigma_epsilon^2 = frac(partial, partial beta) sigma_epsilon^2 = 0
$]
たる点で最小値をとる。これをしばしば*正規方程式*という。

/ $alpha$による偏微分: $alpha$による偏微分を行うと
  $
    frac(partial, partial alpha) sigma_epsilon^2 = 2 (sigma_x^2 + (overline(x))^2) alpha + 2 overline(x) beta - 2 (sigma_(x y) + overline(x) thin overline(y))
  $
  となり、#[@partial]によれば最良の回帰$hat(y_i) = hat(alpha) x_i + hat(beta)$は
  #eqref(
    <alpha-eq>,
    $
      (sigma_x^2 + (overline(x))^2) hat(alpha) + overline(x) hat(beta) = sigma_(x y) + overline(x) thin overline(y)
    $,
  )
  を満たす。
/ $beta$による偏微分: $beta$による偏微分を行うと
  $
    frac(partial, partial beta) sigma_epsilon^2 = 2 overline(x) alpha + 2 beta - 2 overline(y)
  $
  となり、#[@partial]によれば最良の回帰$hat(y_i) = hat(alpha) x_i + hat(beta)$は
  #eqref(
    <beta-eq>,
    $
      overline(x) hat(alpha) + hat(beta) = overline(y)
    $,
  )
  を満たす。

いま、$#[@alpha-eq] - overline(x) times #[@beta-eq]$ を行うことで
$
  overline(x) sigma_x^2 hat(alpha) = overline(x) sigma_(x y) <==> hat(alpha) = frac(sigma_(x y), sigma_x^2)
$
であり、また#[@beta-eq]に代入することで
$
  hat(beta) = overline(y) - overline(x) hat(alpha) = overline(y) - frac(sigma_(x y), sigma_x^2) overline(x)
$
がいえる。

ゆえに最良の回帰直線は
#eqref(
  <line>,
  $
    hat(y_i) = frac(sigma_(x y), sigma_x^2) (x_i - overline(x)) + overline(y)
  $,
)
となる。あるいは相関係数$rho_(x y)$を用いて
#eqref(
  <hat-y>,
  $
    frac(hat(y_i) - overline(y), sigma_y) = rho_(x y) frac(x_i - overline(x), sigma_x)
  $,
)
ともかける。

== 回帰直線の性質

+ #[@beta-eq]より、予測値$hat(y_i)$の平均は観測値$y_i$の平均と等しい
+ すなわち、残差$epsilon_i$の平均は$0$となる
+ #[@hat-y]より、回帰直線は点$(overline(x), overline(y))$を通る
+ 予測値$hat(y_i)$と残差$epsilon_i$の相関係数は$0$である
  #eqref(
    <rel>,
    $
      because rho_(hat(y) epsilon) & = 1/n sum_i (hat(y_i) - overline(y)) (epsilon_i - 0) \
      & = hat(alpha)/n (x_i - overline(x)) (y_i - overline(y) - hat(alpha) (x_i - overline(x))) \
      & = hat(alpha)/n sum_i (x_i - overline(x)) (y_i - overline(y)) - hat(alpha)^2/n sum_i (x_i - overline(x))^2 \
      & = hat(alpha) sigma_(x y) - hat(alpha)^2 sigma_x^2 = hat(alpha) sigma_(x y) - hat(alpha) sigma_(x y) = 0
    $,
  )
+ （*平方和の分解*）応答変数の偏差平方和は、回帰による平方和と残差平方和に分解できる
  #eqref(
    <comp>,
    $
      sum_i (y_i - overline(y))^2 & = sum_i [(hat(y_i) - overline(y)) + (y_i - hat(y_i))]^2 \
      & = sum_i [(hat(y_i) - overline(y)) + epsilon_i]^2 \
      & = underbracket(sum_i (hat(y_i) - overline(y))^2, "回帰による平方和") + underbracket(sum_i epsilon_i^2, "残差平方和") quad (because #[@rel])
    $,
  )

= 決定係数

応答変数の偏差平方和を、回帰による平方和と残差平方和に分解したとき、その比率を*決定係数*あるいは寄与率という。#[@hat-y]より決定係数は
#eqref(
  <decide>,
  $
    frac(sum_i (hat(y_i) - overline(y))^2, sum_i (y_i - overline(y))^2) = rho_(x y)^2 frac(sigma_y^2 sum_i (x_i - overline(x))^2, sigma_x^2 sum_i (y_i - overline(y))^2) = rho_(x y)^2 frac(sigma_y^2 sigma_x^2, sigma_x^2 sigma_y^2) = rho_(x y)^2
  $,
)
とかけて、すなわち決定係数は相関係数の2乗である。

とくに#[@decide]より#[@comp]を変形すると
$
  sum_i epsilon_i^2 = (1 - rho_(x y)^2) sum_i (y_i - overline(y))^2
$
とかけて、とくに$rho_(x y)^2 = 1$のときは$sum_i epsilon_i^2 = 0$となって、すべての観測値は回帰直線によって完全に決定されることが読み取れる。

= 偏相関係数

いま、3つの変量$x$、$y$、$z$があり、$x$と$y$の相関係数を求めたいとする。しかし$x$と$y$の間には変量$z$の影響があり、それが本当に$x$と$y$の相関を反映しているとは限らない。そこでその影響が$z$による回帰式
$
  hat(x_i) = a z_i + b, quad hat(y_i) = c z_i + d
$
で説明できるものと仮定し、その影響を除いた変量
$
  x'_i := x_i - hat(x_i), quad y'_i := y_i - hat(y_i)
$
による相関係数$rho_(x' y')$を考える。これを*偏相関係数*といって$rho_(x y bullet.op z)$と表すものとする。

#[@line]と同様にして
$
  x'_i = x_i - overline(x) - frac(sigma_(x z), sigma_z^2) (z_i - overline(z)), quad
  y'_i = y_i - overline(y) - frac(sigma_(y z), sigma_z^2) (z_i - overline(z))
$
により、$overline(x') = overline(y') = 0$に注意して
$
  sigma_(x')^2 = 1/n sum_i x'_i^2 = 1/n sum_i [(x_i - overline(x)) - frac(sigma_(x z), sigma_z^2) (z_i - overline(z))]^2 = sigma_x^2 - frac(sigma_(x z)^2, sigma_z^2) = sigma_x^2 (1 - rho_(x z)^2)
$
$
  sigma_(y')^2 = 1/n sum_i y'_i^2 = 1/n sum_i [(y_i - overline(y)) - frac(sigma_(y z), sigma_z^2) (z_i - overline(z))]^2 = sigma_y^2 - frac(sigma_(y z)^2, sigma_z^2) = sigma_y^2 (1 - rho_(y z)^2)
$
$
  sigma_(x' y') = 1/n sum_i x'_i y'_i = 1/n sum_i [(x_i - overline(x)) - frac(sigma_(x z), sigma_z^2) (z_i - overline(z))] [(y_i - overline(y)) - frac(sigma_(y z), sigma_z^2) (z_i - overline(z))] = sigma_(x y) - frac(sigma_(x z) sigma_(y z), sigma_z^2) = sigma_x sigma_y (rho_(x y) - rho_(x z) rho_(y z))
$
であるから、偏相関係数は
$
  rho_(x y bullet.op z) = frac(sigma_(x' y'), sigma_(x') sigma_(y')) = frac(rho_(x y) - rho_(x z) rho_(y z), sqrt(1 - rho_(x z)^2) sqrt(1 - rho_(y z)^2))
$
と表される。
