#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "M/M/1モデル",
  description: "M/M/1モデルについて、その周辺知識をインストールする。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)
#let Po = math.op("Po")

#title()
#author()

#outline()

本記事は参考文献#[@ouj]、#[@corona]に基づいて作成した。

= ポアソン過程

次を満たすモデルを*ポアソン過程*と定める。

/ 独立性: 出来事が起きるのはたがいに独立である。
/ 定常性: 出来事が起きる確率はどの時間帯でも同じである。
/ 希少性: 微小時間$Delta t$の間にその出来事が2回以上起きる確率は$omicron(Delta t)$である。

ただし希少性について、微小時間$Delta t$の間にその出来事が起きる確率は$lambda Delta t$であるものとする。
この$lambda$を*生起率*（単位時間当たりの出来事数を指す）という。

ポアソン過程について、以下の二面から分布を考えることができる。

/ ポアソン分布: 出来事が起こる*回数*
/ 指数分布: 出来事が起こる*時間間隔*

= ポアソン分布

時間間隔$(0, t]$の中で、出来事が$k$回起きる確率を$P_k (t)$とする。
このとき$P_k (t)$のなす確率分布は*ポアソン分布*$Po(lambda t)$であることが知られている。
すなわち：
$
  P_k (t) = frac((lambda t)^k, k!) e^(-lambda t)
$

== 微分方程式による導出

ポアソン過程の希少性より、時刻$t + Delta t$において出来事が$n$回起こっている場合は次のいずれかによるとみなせる。

+ 時刻$t$において出来事がすでに$n$回起こっていて、かつ時刻$t$から$t + Delta t$の間に出来事が起こらない場合。
+ 時刻$t$において出来事が$n - 1$回起こっていて、かつ時刻$t$から$t + Delta t$の間に出来事が1回起こる場合。ただし$n = 0$のときを除く。

これより次の方程式が得られる。

$
  P_n (t + Delta t) approx overbracket(P_n (t) (1 - lambda Delta t), "1.") + overbracket(P_(n - 1) (t) (lambda Delta t), "2.")
$

すなわち$Delta t -> 0$として
$ frac(d P_n (t), d t) + lambda P_n (t) = lambda P_(n - 1) (t) $
を得て、この斉次一般解は
$ P_n (t) = A e^(-lambda t) $
である。

いま$n = 0$を仮定すると斉次部分のみが残り、希少性より
$ P_0 (t) = e^(-lambda t) $
を得る。

これを基底ケースとして帰納法を用いることにより
$ P_n (t) = frac((lambda t)^n, n!) e^(-lambda t) $
を得る。

== コーシーの関数方程式による導出

ポアソン過程の独立性と定常性からコーシーの関数方程式
$ P_0 (t_1 + t_2) = P_0 (t_1) P_0 (t_2) $
に帰着され、これは$P_0$の連続性を仮定すれば
$ P_0 (t) = 0, quad P_0 (t) = A e^(-B t) $
と解ける。しかし前者は不適であるため、後者を採択する。

希少性より$A = 1$、$B = lambda$であり、すなわち次を得る：
$ P_0 (t) = e^(-lambda t) $

= 指数分布

時間間隔$T thick (> 0)$の間に出来事が1回も起きない確率$S(T)$は
$ S(T) = P_0 (T) = e^(-lambda T) $
である（ただし、$S(T) = 0 thick /*"for" thick*/ (T < 0)$を約束する）。

つまり関数その確率密度関数$f(t)$について
$ integral_T^infinity f(t) d t = S(T) = e^(-lambda T) $
が成り立つため、この両辺を$T$で微分することで
$ f(T) = lambda e^(-lambda T) $
を得る。

補足。
$S$はコーシーの関数方程式
$ S(T_1 + T_2) = S(T_1) S(T_2) $
を満たすことが知られる。
逆にこれを満たす非零連続関数は指数分布ただ一つである。

= 待ち行列モデル

$M slash M slash 1$モデルとは次の条件を満たす待ち行列モデルである。

/ 客の到着過程: 生起率$lambda$のポアソン分布
/ 客の処理時間: 生起率$mu$の指数分布

時刻$t$において、系内に客が$n$人いる確率を$P_n (t)$とする。

ポアソン過程の希少性より、時刻$t + Delta t$において系内に客が$n$人いる場合は次のいずれかによるとみなせる。

+ 時刻$t$において客がすでに$n$人いて、かつ時刻$t$から$t + Delta t$の間に客が到着せず、かつ客が処理されない場合。
+ 時刻$t$において客が$n - 1$人いて、かつ時刻$t$から$t + Delta t$の間に客が1人到着する場合。ただし$n = 0$のときを除く。
+ 時刻$t$において客が$n + 1$人いて、かつ時刻$t$から$t + Delta t$の間に客が1人処理される場合。

これより次の方程式が得られる。

$
  P_n (t + Delta t) approx overbracket(P_n (t) (1 - lambda Delta t - mu Delta t), "1.") + overbracket(P_(n - 1) (t) (lambda Delta t), "2.") + overbracket(P_(n + 1) (t) (mu Delta t), "3.")
$

すなわち$Delta t -> 0$として
$ frac(d P_n (t), d t) + (lambda + mu) P_n (t) = lambda P_(n - 1) (t) + mu P_(n + 1) (t) $
を得る。同時に$t -> infinity$において定常状態$lim_(t -> infinity) P_n (t) = P_n$となることを仮定して
$
  mu P_(n + 1) - (lambda + mu) P_n + lambda P_(n - 1) = 0
$
とできて、さらに*利用率*$rho = lambda/mu$を用いることで
$
  P_(n + 1) - (1 + rho) P_n + rho P_(n - 1) = 0
$
とかける。

これを解くことにより
$
  P_n = (1 - rho) rho^n
$
が得られる。
これは*幾何分布*と呼ばれる。

ここで定常状態における系内の平均客数は
$
  L = EE[n] = sum_(n = 0)^infinity P_n n = (1 - rho) sum_(n = 0)^infinity n rho^n = text(#red, rho/(1 - rho))
$
であり、平均占有時間（スループットタイム）は、自分自身の処理を含めて
$
  W = EE[frac(n + 1, mu)] = sum_(n = 0)^infinity P_n frac(n + 1, mu) = frac(L + 1, mu) = text(#red, 1/mu dot frac(1, 1 - rho))
$
と求まる。

ここでこれらにおいて満たされる関係式
$
  L = lambda W
$
を*リトルの公式*という。

#bibliography("bib.yaml", style: "ieee")
