#import "../../templates/template.typ": *
#import "../../templates/html.typ": *
#import "../../templates/consts.typ": *
#show: template

#set table(stroke: none)

#set document(
  title: "近似法",
  description: "数値解析における近似法についての解説ページ。Aitkenのdelta^2加速法や指数関数の近似を含む。",
  author: okik-en-data.authors.salty-lemon,
)

#let fr(num, denom) = math.display(cramped: true, math.frac(num, denom))

#show: html-init

#title()
#author()

#outline()

= 平方根の近似

$N in NN without {n^2 mid(|) n in NN}$について、$sqrt(N)$の近似値を得たい。
この近似値を分数などといった形により表す方法を考える。

== 連分数展開

いま$dot(N) = floor(sqrt(N))$は既知であるとすれば
$
  bold(sqrt(N) + tilde(N)) & = 2 tilde(N) + (sqrt(N) - tilde(N)) \
                           & = 2 tilde(N) + frac(N - tilde(N)^2, bold(sqrt(N) + tilde(N)))
$
となり、同じ項$sqrt(N) + tilde(N)$が繰り返される。

次の漸化式
$
  a_(n + 1) = 2 tilde(N) + frac(N - tilde(N)^2, a_n) wide "for" n in NN
$
を満たす数列$(a_n)$を考えよう。$a_0 > 1$のとき$forall n in NN : a_n > 1$であり

$
  abs(a_(n + 1) - (sqrt(N) + tilde(N))) & = abs(frac(N - tilde(N)^2, a_n) - (sqrt(N) - tilde(N))) \
                                        & = frac(sqrt(N) - tilde(N), a_n) abs((sqrt(N) + tilde(N)) - a_n) \
                                        & < abs(a_n - (sqrt(N) + tilde(N)))
$
がわかるから、$(a_n)$は$n -> infinity$で$sqrt(N) + tilde(N)$に収束する。

とくに$a_n = b_n / c_n$、ただし$b_n, c_n in NN$とおけば
$
  b_(n + 1) / c_(n + 1) = 2 tilde(N) + (N - tilde(N)^2) c_n / b_n = frac((2 tilde(N)) b_n + (N - tilde(N)^2) c_n, b_n)
$
であり、これは線形写像として捉えることで
$
  vec(b_n, c_n) = mat(2 tilde(N), N - tilde(N)^2; 1, 0) vec(b_(n - 1), c_(n - 1))
$
とかけて、例えば$a_0 = 2 tilde(N)$とおけばそれなりの精度の近似値が得られるだろう。

== 正則連分数展開

あるいは以下のアルゴリズムで*正則な*連分数に展開できる。

/ 基底: $x_0 = sqrt(N)$とおく。
/ 帰納: $n_k = floor(x_k)$により$x_k = n_k + (x_k - n_k) = n_k + frac(1, (frac(x_k + n_k, x_k^2 - n_k^2)))$とかける。

  すなわち$x_(k + 1) = frac(x_k + n_k, x_k^2 - n_k^2)$とおくと、$x_k = n_k + 1/x_(k + 1)$

ここで$r in NN$について$0 <= (x_r - n_r) < 1$であることに注意すれば、これを$0$あるいは$1$とおいて挟むことで、帰納的に$x_0 = sqrt(N)$の近似値が正則連分数の形で求まる。

とくに$n_(r + 1) = floor(x_(r + 1))$が大きいとき、$1 / x_(r + 1)$は小さくなるため、これを$0$とおいて$x_0$を求めた値$[n_0; n_1, n_2, dots, n_r]$は真の値に近づく。

== Newton法

Newton法は、$f(x) = 0$の根$x = alpha$の付近で、$(a_n, f(a_n))$における接線
$ y - f(a_n) = f'(a_n)(x - a_n) $
と$x$軸、すなわち直線$y = 0$との交点の座標$(a_(n + 1), 0)$における$x$成分$a_(n + 1)$がもとの$a_n$より根$alpha$に近づくことを利用した近似法であり、端的に言えば
$ 0 - f(a_n) = f'(a_n)(a_(n + 1) - a_n) $
すなわち漸化式
$ a_(n + 1) = a_n - frac(f(a_n), f'(a_n)) $
を用いて近似を行う方法である。

例えば$f(x) = x^2 - N$とおくと、$f'(x) = 2x$であるから、$sqrt(N)$の近傍で
$ a_(n + 1) = a_n - frac(a_n^2 - N, 2 a_n) = 1/2 (a_n + N / a_n) $
を繰り返し適用することで、$a_(n + 1)$は$a_n$より真の値$alpha$に近づいてゆくため、$a_n$は$sqrt(N)$に収束する。

あるいは$a_n = b_n/c_n$、ただし$b_n, c_n in NN$とおけば
$ b_(n + 1)/c_(n + 1) = 1/2 (b_n/c_n + N (c_n/b_n)) = frac(b_n^2 + N c_n^2, 2 b_n c_n) $
とも書ける。

Newton法の誤差を解析する。
いま$f$が$alpha$の近傍で$C^infinity$級であればTaylor展開により
$
  f(a_n) &= f(alpha + epsilon_n) = overbracket(f(alpha), 0) + f'(alpha) epsilon_n + 1/2 f''(alpha) epsilon_n^2 + 1/6 f'''(alpha) epsilon_n^3 + O(epsilon_n^4) \
  f'(a_n) &= f'(alpha + epsilon_n) = f'(alpha) + f''(alpha) epsilon_n + 1/2 f'''(alpha) epsilon_n^2 + O(epsilon_n^3)
$
と表される。

いま、$f'(alpha) != 0$を仮定する。Newton法の公式により$beta = frac(f''(alpha), f'(alpha))$、$gamma = frac(f'''(alpha), f'(alpha))$とおくと
$
  epsilon_(n + 1) & = epsilon_n - frac(f(alpha + epsilon_n), f'(alpha + epsilon_n)) \
  & = epsilon_n - frac(f'(alpha) epsilon_n + 1/2 f''(alpha) epsilon_n^2 + 1/6 f'''(alpha) epsilon_n^3 + O(epsilon_n^4), f'(alpha) + f''(alpha) epsilon_n + 1/2 f'''(alpha) epsilon_n^2 + O(epsilon_n^3)) \
  & = epsilon_n - frac(epsilon_n + 1/2 beta epsilon_n^2 + 1/6 gamma epsilon_n^3 + O(epsilon_n^4), 1 + [beta epsilon_n + 1/2 gamma epsilon_n^2 + O(epsilon_n^3)])
$
と表される。ここで、Maclaurin展開より$frac(1, 1 + x) = 1 - x + x^2 - x^3 + O(x^4)$とかけて
$
  epsilon_(n + 1) &= epsilon_n - (epsilon_n + 1/2 beta epsilon_n + 1/6 gamma epsilon_n^3 + O(epsilon_n^4))(1 - beta epsilon_n - 1/2 gamma epsilon_n^2 + beta^2 epsilon_n^2 + O(epsilon_n^3)) \
  &= epsilon_n - [epsilon_n - 1/2 beta epsilon_n^2 - (1/2 beta^2 + 1/3 gamma) epsilon_n^3 + O(epsilon_n^4)] \
  &= 1/2 beta epsilon_n^2 + (1/2 beta^2 + 1/3 gamma) epsilon_n^3 + O(epsilon_n^4)
$
とかけるため、とくに$f'(alpha) != 0$を仮定すると、Newton法は$f''(alpha) != 0$であるとき$2$次収束し、$f''(alpha) = 0$であるとき$3$次収束する。

== Aitkenの$delta^2$加速法

Richardsonの加速法とは、ある数列$(a_n)$とその収束値$lim_(n -> infinity) a_n = alpha$について、その誤差が収束率$gamma$と係数$C$を用いて
$ a_n - alpha approx C gamma^n $
と表せるとき、すなわち数列$(a_n)$が等比的であるとき、$a_(n + 1) - gamma a_n$を用いることによって$C$を消去して
$ a_(n + 1) - gamma a_n approx alpha(1 - gamma) $
すなわち
$ alpha approx frac(a_(n + 1) - gamma a_n, 1 - gamma) $
と書けることを利用して、新たに$(hat(a)_n)$を
$ hat(a)_n = frac(a_(n + 1) - gamma a_n, 1 - gamma) $
と定義する方法である。

ここで実際には
$ a_n - alpha = C gamma^n + epsilon_n $
であるとすれば
$
  hat(a)_n - alpha & = frac((alpha + C gamma^(n + 1) + epsilon_(n + 1)) - gamma (alpha + C gamma^n + epsilon_n), 1 - gamma) - alpha \
  & = frac(epsilon_(n + 1) - gamma epsilon_n, 1 - gamma) \
  & = frac(epsilon_(n + 1) - epsilon_n, 1 - gamma) + epsilon_n
$
となり、$epsilon_(n + 1) - epsilon_n$は十分に小さいと考えられるので、この数列$(hat(a)_n)$はもとの数列$(a_n)$より$alpha$に近く、より速く収束するといえる。

Aitkenの$delta^2$加速法とは、上記の収束率$gamma$が未知のときにこれを
$ gamma_((n)) approx frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n) $
と近似して上のRichardsonの加速法を適用する方法である。

実際にこれを代入して
$
  hat(a)_n &= frac(a_(n + 1) - gamma_((n)) a_n, 1 - gamma_((n))) \
  &= frac(a_(n + 1) - frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n) a_n, 1 - frac(a_(n + 2) - a_(n + 1), a_(n + 1) - a_n)) \
  &= frac(a_(n + 2) a_n - a_(n + 1)^2, a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= frac(a_(n + 2) a_n + (- 2 a_(n + 1) + a_n) a_n - a_(n + 1)^2 - (- 2 a_(n + 1) + a_n) a_n, a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= frac((a_(n + 2) - 2 a_(n + 1) + a_n) a_n - (a_(n + 1)^2 - 2 a_(n + 1) a_n + a_n^2), a_(n + 2) - 2 a_(n + 1) + a_n) \
  &= a_n - frac((a_(n + 1) - a_n)^2, a_(n + 2) - 2 a_(n + 1) + a_n)
$
を得る。ここで、$delta a_n = a_(n + 1) - a_n$、$delta^2 a_n = a_(n + 2) - 2 a_(n + 1) + a_n$とおくことにより、Aitkenの$delta^2$加速法における加速列
$ hat(a)_n = a_n - frac(delta a_n^2, delta^2 a_n) $
を得る。

さて、前節のNewton法で得られる数列について
$ a_(n + 1) = 1/2 (a_n + N / a_n), wide a_(n + 2) = 1/2 (a_(n + 1) + N / a_(n + 1)) $
であるから、$delta a_n$および$delta^2 a_n$を計算すると
$
    delta a_n & = a_(n + 1) - a_n = - 1/2 (a_n - N / a_n) \
  delta^2 a_n & = a_(n + 2) - 2 a_(n + 1) + a_n \
              & = - 1/2 (a_(n + 1) - N / a_(n + 1)) + 1/2 (a_n - N / a_n) \
              & = (-1/2)^2 [-2 (a_(n + 1) - N / a_(n + 1)) + 2 (a_n - N / a_n)] \
              & = (-1/2)^2 [- (a_n + N / a_n) + 4 N (a_n - N / a_n)^(-1) + 2 (a_n - N / a_n)] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [- (a_n + N / a_n)^2 + 4 N + 2 (a_n + N / a_n) (a_n - N / a_n)] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [- a_n^2 - 2 N - (N / a_n)^2 + 4 N + 2 a_n^2 - 2 (N / a_n)^2] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) [a_n^2 + 2 N - 3 (N / a_n)^2] \
              & = (-1/2)^2 (a_n + N / a_n)^(-1) (a_n - N / a_n) (a_n + 3 N/ a_n)
$
より加速列として
$
  hat(a)_n & = a_n - frac(delta a_n^2, delta^2 a_n) \
           & = a_n - (a_n - N / a_n)^cancel(2) (a_n + N / a_n) cancel((a_n - N / a_n)^(-1)) (a_n + 3 N / a_n)^(-1) \
           & = [a_n (a_n + 3 N / a_n) - (a_n - N / a_n) (a_n + N / a_n)](a_n + 3 N / a_n)^(-1) \
           & = [(cancel(a_n^2) + 3 N) - (cancel(a_n^2) - N^2/a_n^2)](a_n + 3 N / a_n)^(-1) \
           & = (3 N + N^2 / a_n^2) (a_n + 3 N / a_n)^(-1) \
           & = N / a_n (3 a_n + N / a_n) (a_n + 3 N / a_n)^(-1)
$
が得られる。

ここで、数列$(a_n)$の十分大きい項$a_i$を求めて加速列$(hat(a)_n)$を生成し、$hat(a)_i$を求めてもいいが、一般には$a_n <- hat(a)_(n - 1)$としてしまい漸化式とみなして反復する方法がとられる。これはいわば加速列の加速列の…加速列を求めることであり、この列がより速く真の値に収束することは、加速法の原理からも明らかであろう。

$
  tilde(a)_(n + 1) = (N / tilde(a)_n) frac(3 tilde(a)_n + (N / tilde(a)_n), tilde(a)_n + 3 (N / tilde(a)_n))
$

= ネイピア数および冪乗の近似

== 連分数展開

一般に次が知られている。

#eqref(
  <efrac>,
  $
    e^frac(2 x, y, style: "horizontal") = 1 + fr(2 x, (y - x) + fr(x^2, 3 y + fr(x^2, 5 y + fr(x^2, 7 y + fr(x^2, 9 y + dots.down)))))
  $,
)

=== $e$の近似

$x = 1$、$y = 2$として#[@efrac]に代入すると
$
  e = 1 + fr(2, 1 + fr(1, 6 + fr(1, 10 + cancel(cross: #true, fr(1, 14 + dots.down))))) approx 1 + fr(2, 1 + fr(1, 6 + fr(1, 10))) = fr(193, 71)
$

実際に、$e = underline(2.718)28 dots$かつ$frac(193, 71) = underline(2.718)30 dots$である。

=== $root(n, e)$の近似

#[@efrac]に$x = 1$、$y = 2n$を代入して以下のように打ち切る。
$
  root(n, e) = 1 + fr(2, 2n - 1 + fr(1, 6n + cancel(cross: #true, fr(1, 10n + dots.down)))) approx 1 + fr(2, 2n - 1 + fr(1, 6n)) = frac(12n^2 + 6n + 1, 12n^2 - 6n + 1) eq.delta f(n)
$

これを用いて計算を行うと、以下のように高精度の近似が得られる。

#figure(
  caption: [$n$と$f(n)$の対応],
  table(
    align: center + horizon,
    columns: (8em,) + (3em,) * 7,
    rows: (2em, 3em),
    table.vline(x: 1),
    table.hline(),
    $n$, $0$, $1$, $2$, $3$, $4$, $5$, $6$,
    table.hline(),
    $f(n) approx root(n, e)$, $1$, $19/7$, $61/37$, $127/91$, $217/169$, $331/271$, $469/397$,
    table.hline(),
  ),
)

=== $e^n$の近似

#[@efrac]に$x = n$、$y = 2$を代入する。
$
  e^n = 1 + fr(2 n, 2 - n + fr(n^2, 6 + fr(n^2, 10 + fr(n^2, 14 + fr(n^2, 18 + fr(n^2, 22 + dots.down))))))
$

精度の高い近似を行うには、指数$n$に対して最低でも$4 n + 6$の項までを残す必要がある。

#figure(
  caption: [$n$と$f_(4n + 6) (n)$の対応],
  table(
    align: center + horizon,
    columns: (8em,) + (3em,) * 4,
    rows: (2em, 3em),
    table.vline(x: 1),
    table.hline(),
    $n$, $0$, $1$, $2$, $3$,
    table.hline(),
    $f_(4n + 6) (n) approx e^n$, $1$, $193/71$, $133/18$, $4439/221$,
    table.hline(),
  ),
)

== Maclaurin展開

$f(x) = e^x$について$f = f^((1)) = f^((2)) = dots.c$であるから、そのMaclaurin展開は
$
  f(x) = sum_(n = 0)^(infinity) frac(x^n, n!)
$
とかけて、しかもd#{ sym.acute }Alembertの公式によりその収束半径$r$は
$
  r = lim_(n -> infinity) abs(frac(a_n, a_(n + 1))) = lim_(n -> infinity) frac((n + 1)!, n!) = lim_(n -> infinity) (n + 1) = infinity
$
であるから、$x in RR$に対してこの展開は絶対収束する。

例えばこれを打ち切って
$
  f_n (x) = sum_(k = 0)^n frac(x^k, k!)
$
とおけば、$lim_(n -> infinity) f_n (x) = e^x$である一方で、有限の$n$に対してもある程度の近似が得られる。

ただし、最良近似ではない。

#figure(
  caption: [$n$と$f_n (1)$の対応],
  table(
    align: center + horizon,
    columns: (6em,) + (3.5em,) * 10,
    rows: (2em, 3em, 2em),
    table.vline(x: 1),
    table.hline(),
    $n$, $0$, $1$, $2$, $3$, $4$, $5$, $6$, $7$, $8$, $9$,
    table.hline(),
    $f_n (1)$, $1$, $2$, $5/2$, $8/3$, $65/24$, $163/60$, $1957/720$, $685/252$, $109601/40320$, $98641/36288$,
    $e - f_n (1)$, $1.72$, $0.72$, $0.22$, $0.05$, $10^(-2)$, $10^(-3)$, $10^(-4)$, $10^(-5)$, $10^(-6)$, $10^(-7)$,
    table.hline(),
  ),
)

#figure(
  caption: [$n$と$f_n (2)$の対応],
  table(
    align: center + horizon,
    columns: (6em,) + (3.5em,) * 10,
    rows: (2em, 3em, 2em),
    table.vline(x: 1),
    table.hline(),
    $n$, $0$, $1$, $2$, $3$, $4$, $5$, $6$, $7$, $8$, $9$,
    table.hline(),
    $f_n (2)$, $1$, $3$, $5$, $19/3$, $7$, $109/15$, $331/45$, $155/21$, $2327/315$, $20947/2835$,
    $e^2 - f_n (2)$, $6.39$, $4.39$, $2.39$, $1.06$, $0.39$, $0.12$, $0.03$, $10^(-2)$, $10^(-3)$, $10^(-4)$,
    table.hline(),
  ),
)

#figure(
  caption: [$n$と$f_n (frac(1, 2, style: "horizontal"))$の対応],
  table(
    align: center + horizon,
    columns: (8em,) + (3.5em,) * 7,
    rows: (2em, 3em, 3em),
    table.vline(x: 1),
    table.hline(),
    $n$, $0$, $1$, $2$, $3$, $4$, $5$, $6$,
    table.hline(),
    $f_n (frac(1, 2, style: "horizontal"))$, $1$, $3/2$, $13/8$, $79/48$, $211/128$, $6331/3840$, $75973/46080$,
    $e^(1/2) - f_n (frac(1, 2, style: "horizontal"))$,
    $0.65$,
    $0.15$,
    $0.02$,
    $10^(-3)$,
    $10^(-4)$,
    $10^(-5)$,
    $10^(-6)$,
    table.hline(),
  ),
)

とくに$x$が大きくなると、$f_n (x)$は$e^x$に近づくのが遅くなることがわかる。
ゆえに特に大きい$x$に対しては向いていない。
