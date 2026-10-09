#import "/lib/utils.typ": *

#let document-config = (
  title: "線形単回帰と最小二乗法",
  description: "最小二乗法はどのようにして導出されるのか。",
  author: "Salty Lemon",
)

#show: previewer(document-config)

= 線形単回帰

相関とは、2変量$(x, y)$の間の間にある関係のことを指す。
相関に対して、説明変数$x$から目的変数$y$の予測を目指すことを単回帰という。

例えば一次関数による単回帰を考える。目的変数$y$が説明変数$x$の一次関数であると主張したいものとする。

$ hat(y_i) = alpha x_i + beta $

しかしこのとき、実際には誤差$delta$が発生し、これを*残差*と呼ぶ。

$ y_i = alpha x_i + beta + delta_i thick (= hat(y_i) + delta_i) $

よりよい説明のためには、残差が最小であることが望ましい。その基準として残差の分散$sigma_delta^2$を最小化することが考えられる。

$ sigma_delta^2 = 1/n sum_i delta_i^2 = 1/n sum_i (y_i - hat(y_i))^2 = 1/n sum_i (alpha x_i + beta - y_i)^2 $

これを*最小二乗法*またはLSM(Least Squares Method)という。
（注：厳密には、残差の分散ではなく*残差平方和*$sum_i delta_i^2$を最小化するものであるが、標本数$n$を固定した場合これらは同一視できる。）

= 最小二乗法

== 正規方程式

残差の分散を$alpha$および$beta$について整理すると
$
  sigma_delta^2 & = 1/n sum_i (x_i alpha + beta - y_i)^2 \
  & = 1/n sum_i (x_i^2 alpha^2 + 2 x_i alpha beta + beta^2 - 2 x_i y_i alpha - 2 y_i beta + y_i^2) \
  & = (1/n sum_i x_i^2) alpha^2 + 2 (1/n sum_i x_i) alpha beta + beta^2 - 2 (1/n sum_i x_i y_i) alpha - 2 (1/n sum_i y_i) beta + (1/n sum_i y_i^2) \
  & = (sigma_x^2 + (overline(x))^2) alpha^2 + 2 overline(x) alpha beta + beta^2 - 2 (sigma_(x y) + overline(x) thin overline(y)) alpha - 2 overline(y) beta + sigma_y^2 + (overline(y))^2
$
となる。

ここで$alpha$と$beta$を変数とみれば、$sigma_delta^2$は二次式であり、しかも$alpha^2$および$beta^2$の係数は正であるため、$sigma_delta^2$は凸関数である。

すなわち$sigma_delta^2$は
#eqref(<partial>)[$
  frac(partial, partial alpha) sigma_delta^2 = frac(partial, partial beta) sigma_delta^2 = 0
$]
たる点で最小値をとる。これをしばしば*正規方程式*という。

/ $alpha$による偏微分: $alpha$による偏微分を行うと
  $
    frac(partial, partial alpha) sigma_delta^2 = 2 (sigma_x^2 + (overline(x))^2) alpha + 2 overline(x) beta - 2 (sigma_(x y) + overline(x) thin overline(y))
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
    frac(partial, partial beta) sigma_delta^2 = 2 overline(x) alpha + 2 beta - 2 overline(y)
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

== 回帰の現象

いま、説明変数$x$と応答変数$y$が同一の分布に従っているものとする。

とくに$overline(x) = overline(y) = mu$とすれば、#[@hat-y]の両辺に$sigma_x = sigma_y = sigma$をかけることにより
$
  abs(hat(y_i) - mu) = abs(rho_(x y)) abs(x_i - mu) <= abs(x_i - mu)
$
が得られ、$abs(rho_(x y)) != 1$のとき応答変数は説明変数より平均に近づく性質があるとわかる。

これを*回帰の現象*あるいは平均への回帰という。

平均への回帰を誤って解釈してしまうことを*回帰の過誤*という。例えば、「昨日行ったテストは平均点を下回っていた。そこで勉強するように注意したところ、今回は平均点に近づいた。これはその注意によるものである。」など。

== 回帰直線の性質

+ #[@beta-eq]より、予測値$hat(y_i)$の平均は観測値$y_i$の平均と等しい
+ すなわち、残差$delta_i$の平均は$0$となる
+ #[@hat-y]より、回帰直線は点$(overline(x), overline(y))$を通る
+ 予測値$hat(y_i)$と残差$delta_i$の相関係数は$0$である
  #eqref(
    <rel>,
    $
      because rho_(hat(y) delta) & = 1/n sum_i (hat(y_i) - overline(y)) (delta_i - 0) \
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
      & = sum_i [(hat(y_i) - overline(y)) + delta_i]^2 \
      & = underbracket(sum_i (hat(y_i) - overline(y))^2, "回帰による平方和") + underbracket(sum_i delta_i^2, "残差平方和") quad (because #[@rel])
    $,
  )

== 決定係数

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
  sum_i delta_i^2 = (1 - rho_(x y)^2) sum_i (y_i - overline(y))^2
$
とかけて、とくに$rho_(x y)^2 = 1$のときは$sum_i delta_i^2 = 0$となって、すべての観測値は回帰直線によって完全に決定されることが読み取れる。

= 擬相関

有名な例を挙げよう。一般に、アイスクリームへの支出が増えると水難事故も増えることが知られている。しかし、これはアイスクリームが水難事故を引き起こしているのではなく、夏になって気温が上昇することでアイスクリームへの支出が増えると同時に海や川での水難事故が増えることによる。
このように、ある変量$x$と$y$との間に認められる相関関係が、第三の変量$z$によるものであるとき、これを*見かけの相関*、あるいは*擬相関*と呼ぶ。

例えば、アメリカのあるスーパーにおけるビールの売り上げと赤ちゃん用おむつの売り上げには相関が見つかったという。一体なぜだろうか？（もちろん、アメリカの赤ちゃんがビールを嗜む、というわけではない。）

== 偏相関係数

いま、3つの変量$x$、$y$、$z$があり、$x$と$y$の相関係数を求めたいとする。しかし$x$と$y$の間には変量$z$の影響があり、それが本当に$x$と$y$の相関を反映しているとは限らない（見かけの相関）。そこでその影響が$z$による回帰式
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

= 線形単回帰における回帰係数の区間推定

いま、誤差項$epsilon_i$は互いに独立で正規分布$N(0, sigma^2)$に従う確率変数であるものとし、目的変数$y_i$は説明変数$x_i$と誤差項$epsilon_i$によって
$
  y_i = alpha x_i + beta + epsilon_i
$
と表されるものとする。
このとき、最小二乗法によって得られた回帰係数の点推定値$hat(alpha)$および$hat(beta)$を考える（以下では主に$hat(alpha)$について議論を行う）。

== 回帰係数$hat(alpha)$の分布

以下、$T_(circle circle.filled) := sum_i (circle_i - overline(circle)) (circle.filled_i - overline(circle.filled))$と書くものとする。

$x$と$y$の偏差の積の和は
$
  T_(x y) = sum_i (x_i - overline(x)) (y_i - overline(y)) = sum_i (x_i - overline(x)) (alpha (x_i - overline(x)) + epsilon_i) = T_(x x) alpha + sum_i (x_i - overline(x)) epsilon_i
$
であるから、とくに重みを$w_i := (x_i - overline(x)) T_(x x)^(-1)$とおけば次のように書ける。
#eqref(
  <hat-alpha>,
  $
    hat(alpha) = frac(sigma_(x y), sigma_x^2) = frac(T_(x y), T_(x x)) = alpha + sum_i w_i epsilon_i
  $,
)

とくにその平均と分散について
$
  EE[hat(alpha)] = EE[alpha + sum_i w_i epsilon_i] = alpha + sum_i w_i EE[epsilon_i] = alpha
$
$
  Var(hat(alpha)) = Var(alpha + sum_i w_i epsilon_i) = Var(sum_i w_i epsilon_i) = sum_i w_i^2 Var(epsilon_i) = sigma^2 sum_i w_i^2 = frac(sigma^2, T_(x x))
$
$
  se(hat(alpha)) = frac(sigma, sqrt(T_(x x)))
$
がいえるため、$hat(alpha)$は$alpha$の不偏推定量であり、また正規分布の再生性から$hat(alpha)$は正規分布$N(alpha, frac(sigma^2, T_(x x)))$に従う。

== 回帰係数$hat(beta)$の分布

#[@hat-alpha]より
#eqref(
  <hat-beta>,
  $
    hat(beta) = overline(y) - hat(alpha) overline(x) = overline(y) - alpha overline(x) - overline(x) sum_i w_i epsilon_i = beta - overline(x) sum_i w_i epsilon_i + overline(epsilon)
  $,
)
であるから、その平均と分散について
$
  EE[hat(beta)] = EE[beta - overline(x) sum_i w_i epsilon_i + overline(epsilon)] = beta - overline(x) sum_i w_i EE[epsilon_i] + n^(-1) sum_i EE[epsilon_i] = beta
$
$
  Var(hat(beta)) = Var(beta - overline(x) sum_i w_i epsilon_i + overline(epsilon)) = (overline(x))^2 sum_i w_i^2 Var(epsilon_i) + n^(-2) sum_i Var(epsilon_i) = sigma^2/n [(frac(overline(x), sigma_x))^2 + 1]
$
$
  se(hat(beta)) = frac(sigma, sqrt(n)) sqrt((frac(overline(x), sigma_x))^2 + 1)
$
がいえるため、$hat(beta)$は$beta$の不偏推定量であり、また正規分布の再生性から$hat(beta)$は正規分布$N(beta, sigma^2/n [(frac(overline(x), sigma_x))^2 + 1])$に従う。

== 残差分散$hat(sigma^2)$の不偏推定量

いま、*残差*を$delta_i := y_i - hat(y_i) = (alpha - hat(alpha)) x_i + (beta - hat(beta)) + epsilon_i$とする。

#[@hat-alpha]、#[@hat-beta]、および$w_i = (x_i - overline(x)) T_(x x)^(-1)$より
$
  delta_i = (epsilon_i - overline(epsilon)) - T_(x x)^(-1) (x_i - overline(x)) sum_j (x_j - overline(x)) epsilon_j
$
である。ここで、$T := sum_i (x_i - overline(x)) epsilon_i$とおけば、残差平方和は
$
  sum_i delta_i^2 = underbracket(sum_i (epsilon_i - overline(epsilon))^2, P) - 2 underbracket(T/T_(x x) sum_i (epsilon_i - overline(epsilon)) (x_i - overline(x)) epsilon_j, Q) + underbracket(T^2/T_(x x)^2 sum_i (x_i - overline(x))^2, R)
$
とかける。

/ $P$の計算: $
    P = sum_i epsilon_i^2 - 2 overline(epsilon) dot (sum_i epsilon_i) + sum_i (overline(epsilon))^2 = sum_i epsilon_i^2 - 2 overline(epsilon) dot n overline(epsilon) + n (overline(epsilon))^2 = sum_i epsilon_i^2 - n (overline(epsilon))^2
  $
/ $Q$の計算: $
    Q = T/T_(x x) [sum_i epsilon_i (x_i - overline(x)) - overline(epsilon) sum_i (x_i - overline(x)) = T/T_(x x) (T - 0) = T^2/T_(x x)
  $
/ $R$の計算: $ R = T^2/T_(x x)^2 dot T_(x x) = T^2/T_(x x) $

以上より
$
  sum_i delta_i^2 = sum_i epsilon_i^2 - n (overline(epsilon))^2 - 2 T^2/T_(x x) + T^2/T_(x x) = sum_i epsilon_i^2 - 1/n (sum_i epsilon_i)^2 - 1/T_(x x) [sum_i (x_i - overline(x)) epsilon_i]^2
$
がいえる。

ここで$EE[X] = 0 ==> EE[X^2] = E[(X - EE[X])^2] = Var(x)$に注意して、上の式の期待値を求めると
$
    & EE[sum_i delta_i^2] \
  = & sum_i EE[epsilon_i^2] - 1/n EE[(sum_i epsilon_i)^2] - 1/T_(x x) EE[(sum_i (x_i - overline(x)) epsilon_i)^2] \
  = & sum_i Var(epsilon_i) - 1/n Var(sum_i epsilon_i) - 1/T_(x x) Var(sum_i (x_i - overline(x)) epsilon_i) \
  = & sum_i Var(epsilon_i) - 1/n sum_i Var(epsilon_i) - 1/T_(x x) sum_i (x_i - overline(x))^2 dot Var(epsilon_i) \
  = & n sigma^2 - 1/n (n sigma^2) - 1/T_(x x) underbracket(sum_i (x_i - overline(x))^2, T_(x x)) dot sigma^2 \
  = & n sigma^2 - sigma^2 - sigma^2 \
  = & (n - 2) sigma^2
$
となり、ゆえに$EE[hat(sigma)^2] = sigma^2$を満たすような$sigma^2$の不偏推定量$hat(sigma)^2$は
$
  hat(sigma)^2 = 1/(n - 2) sum_i delta_i^2 = 1/(n - 2) sum_i (y_i - hat(y_i))^2
$
であることがわかる。

=== 補足 --- 計算のコツ

計算の際は$hat(y_i) - overline(y) = T_(x y)/T_(x x) (x_i - overline(x))$に注意して
$
  & sum_i (y_i - hat(y_i))^2 \
  = & sum_i [(y_i - overline(y)) - (hat(y_i) - overline(y))]^2 \
  = & sum_i [(y_i - overline(y)) - T_(x y)/T_(x x) (x_i - overline(x))]^2 \
  = & sum_i (y_i - overline(y))^2 - 2 T_(x y)/T_(x x) sum_i (y_i - overline(y)) (x_i - overline(x)) + T_(x y)^2/T_(x x)^2 sum_i (x_i - overline(x))^2 \
  = & T_(y y) - 2 T_(x y)/T_(x x) dot T_(x y) + T_(x y)^2/T_(x x)^2 dot T_(x x) \
  = & T_(y y) - T_(x y)/T_(x x) dot T_(x y) \
  = & T_(y y) - hat(alpha) T_(x y)
$
であることをを用いるとよい。

== 統計量

ここで二つの統計量を導入する。

まず、回帰係数$hat(alpha)$は正規分布$N(alpha, sigma^2/T_(x x))$に従うのであったから、これを標準化した統計量
$
  z := frac(hat(alpha) - alpha, frac(sigma, sqrt(T_(x x)), style: "horizontal"))
$
は標準正規分布$N(0, 1)$に従うことがわかる。

これと対比して、$sigma$を$hat(sigma)$で置き換えた統計量
$
  t := frac(hat(alpha) - alpha, frac(hat(sigma), sqrt(T_(x x)), style: "horizontal"))
$
を考えると、Cochranの定理より$sigma^(-2) sum_i delta_i^2$は$chi^2(n - 2)$に従うことが知られているため、その帰結として$t$は自由度$n - 2$の$t$分布$t(n - 2)$に従うことが示される。
