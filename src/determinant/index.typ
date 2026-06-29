#import "@preview/cetz:0.5.2"
#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "行列式の定義",
  description: "行列式の最高次外冪による定義を説明したページ。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)

#let ip(a, b) = $lr(chevron.l #a, #b chevron.r)$

#title()
#author()

#outline()

= 双線形写像

次を満たす写像$f: RR^n times RR^n -> V$を*双線形写像*という。
+ $forall a, b, c in RR^n: f(a + b, c) = f(a, c) + f(b, c)$
+ $forall a, b, c in RR^n: f(a, b + c) = f(a, b) + f(a, c)$
+ $forall a, b in RR^n, forall lambda in RR: f(lambda a, b) = f(a, lambda b) = lambda f(a, b)$

= 内積

$a in RR^n$と$b in RR^n$の内積$RR^n times RR^n -> RR$を次で定義する。
$ ip(a, b) = sum_(i = 0)^(n - 1) a_i b_i $

これは双線形写像として扱うことができる。しかし一般に、双線形写像の条件を満たすような写像$f: RR^n times RR^n -> RR^n times RR^n$は存在しない。
なぜならば、そのような写像$f$があるならば
$
  f(0, a) = f(0 + 0, a) = f(0, a) + f(0, a)
$
より、$f(0, a) = 0$でなければならず、同様に$a != b$たる$b$をとっても、$f(0, b) = 0$となり矛盾する。

そこで、$RR^n times RR^n$上ではなく、新たな線形空間$RR^n times.o RR^n$への双線形写像を考える。

= Tensor積

今、$RR^n$の標準基底$cal(E) = {e_0, e_1, dots, e_(n - 1)}$について、形式的な記号$times.o$により${e_i times.o e_j}$を基底とする線形空間を$RR^n times.o RR^n = {sum_(i, j) lambda_(i, j) (e_i times.o e_j) mid(|) lambda_(i, j) in RR}$とする。

いま、演算$times.o: RR^n times RR^n -> RR^n times.o RR^n$を次で定義する。
$
  (sum_i lambda_i e_i) times.o (sum_j mu_j e_j) = sum_(i, j) lambda_i mu_j (e_i times.o e_j)
$

ここで演算$times.o$は*Tensor積*といわれる。
ここでTensor積は双線形写像である。

#figure(
  caption: [内積],
  frame-it(cetz.canvas({
    import cetz.draw: *
    set-style(content: (padding: 4pt), line: (mark: (end: ")>", fill: black)))

    content((0, 2), $RR^n times RR^n$, name: "1")
    content((0, 0), $RR^n times.o RR^n$, name: "2")
    content((4, 0), $RR$, name: "3")

    line("1", "2", name: "otimes")
    content(("otimes.start", 50%, "otimes.end"), anchor: "east", $times.o$)
    line("2", "3", name: "f", stroke: (dash: (2pt, 1pt)))
    content(("f.start", 40%, "f.end"), anchor: "south", $f$)
    content(("f.start", 40%, "f.end"), anchor: "north", text(size: 8pt, "(一意に存在)"))
    line("1", "3", name: "ip")
    content(("ip.start", 50%, "ip.end"), anchor: "south-west", "内積")
  })),
)

さらに、例えば$RR^n$上の内積$RR^n times RR^n --> RR$について、写像$f: RR^n times.o RR^n -> RR$を任意の標準基底$e_i$、$e_j$に対して
$
  f(e_i times.o e_j) = ip(e_i, e_j)
$
を満たす線形写像として定めると、任意の$a, b in RR^n$に対して
$
  f(a times.o b) = ip(a, b)
$
が成り立ち、しかも$f$は一意的である（ことが示される）。

とくに具体的な計算を行うと
$
  ip(vec(a_0, dots.v, a_(n-1)), vec(b_0, dots.v, b_(n-1))) = sum_(i=0)^(n-1) a_i b_i
$
であるから、$RR^n$の標準基底について
$
  f(e_i times.o e_j) = delta_(i, j)
$
が示される。ゆえに線形写像$f$は
$
  f(sum_(i, j) lambda_(i, j) (e_i times.o e_j)) = sum_(i, j) lambda_(i, j) delta_(i, j) = sum_i lambda_(i, i) = tr(lambda_(i, j))
$
であることがわかる。

= 商空間

#figure(
  caption: [商空間],
  frame-it(cetz.canvas({
    import cetz.draw: *
    set-style(content: (padding: 2pt))

    content((2.5, 2), anchor: "south", $->^p$)
    circle((4, 1.3), radius: 0.02, fill: black, name: "0")
    content("0", anchor: 230deg, $0$)
    rect((0, 0), (2, 0.8), fill: luma(128), stroke: (dash: "densely-dashed"))
    content((1, 0.4), $W$)
    line((2, 0.8), (2, 0), "0", close: true, stroke: (dash: (2pt, 1pt), thickness: 0.5pt), fill: luma(216))
    rect((0, 0), (2, 2))
    content((1, 2), anchor: "south", $V$)
    rect((3, 1), (5, 2))
    content((4, 2), anchor: "south", $V slash W$)

    line((2, 2), (3, 2), stroke: (dash: "densely-dashed"))
    line((2, 0), (3, 1), stroke: (dash: "densely-dashed"))
  })),
)

ある全射たる線形写像$p: V -> V'$と始域の部分空間$W subset.eq V$が与えられたとき、$"Ker" p = {x in V mid(|) p(x) = 0} = W$となるように空間$V'$をとることができ、しかもその取り方は一意的である。この線形空間$V'$を*商空間*$V slash W$という。

= 外冪と行列式

$RR^n$におけるTensor積空間
$
  frak(P)_r colon.eq lr(chevron.l a_0 times.o dots.c times.o a_(r - 1) mid(|) a_0, dots, a_(r - 1) in RR^n chevron.r)
$
について、その部分（線形）空間
$
  frak(R)_r colon.eq lr(chevron.l a_0 times.o dots.c times.o a_i times.o dots.c times.o a_j times.o dots.c times.o a_(r - 1) mid(|) a_0, dots, a_(r - 1) in RR^n \; i != j and a_i = a_j chevron.r) subset.eq frak(P)_r
$
による商空間$frak(P)_r slash frak(R)_r$を、$RR^n$の$r$次*外冪*といって、$Lambda^r RR^n$と表す。

ここで$a_0 times.o dots.c times.o a_(r - 1)$の像を$a_0 and dots.c and a_(r - 1)$と書き表す。

いま、$n = r = 2$として考えると、
#eqref(
  <eq0>,
  $
    x times.o x in frak(R)_2 wide therefore x and x = 0
  $,
)
であり、#[@eq0]において$x = e_0 + e_1$とすることで
$
  (e_0 + e_1) and (e_0 + e_1) = e_0 and e_0 + e_0 and e_1 + e_1 and e_0 + e_1 and e_1 = 0
$
が得られる。同時に#[@eq0]において$x = e_0$あるいは$x = e_1$とすることで得られる
$
  e_0 and e_0 = e_1 and e_1 = 0
$
を利用して
$
  e_0 and e_1 = - e_1 and e_0
$
を得る。ゆえに一般の$RR^2$上の元$a e_0 + c e_1$および$b e_0 + d e_1$について
#eqref(
  <ad-bc>,
  $
    (a e_0 + c e_1) and (b e_0 + d e_1) & = a b (e_0 and e_0) + a d (e_0 and e_1) + c b (e_1 and e_0) + c d (e_1 and e_1) \
                                        & = a b 0 + a d (e_0 and e_1) + c b (- e_0 and e_1) + c d 0 \
                                        & = (a d - b c) (e_0 and e_1)
  $,
)
と計算できることがわかる。

一般に、$dim Lambda^n RR^n = 1$であることが知られており、しかもその基底は$e_0 and dots.c and e_(n-1)$である。ゆえに$a_0, dots, a_(n - 1)$に対して、ある実数$det (a_0, dots, a_(n - 1)) in RR$が存在して
$
  det (a_0, dots, a_(n - 1)) = frac(a_0 and dots.c and a_(n - 1), e_0 and dots.c and e_(n-1))
$
とかける。これを行列$(a_0, dots, a_(n - 1))$の*行列式*という。

例えば、#[@ad-bc]によれば
$
  det mat(a, b; c, d) = a d - b c
$
である。
