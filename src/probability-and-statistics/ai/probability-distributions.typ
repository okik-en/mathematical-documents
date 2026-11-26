#import "@preview/cetz:0.5.2"
#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let Ex = math.class("normal", math.italic("Ex"))

#let document-config = (
  title: "確率分布のまとめ",
  description: "二項分布、ポアソン分布、指数分布、正規分布など、基本的な確率分布の動機・定義・覚え方をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "確率分布"),
)

#show: previewer(document-config)

統計検定2級の範囲に含まれる基本的な確率分布について、*なぜその分布を考えるのか（動機）*、定義、平均・分散、覚え方をまとめる。
$chi^2$分布・$t$分布・$F$分布などは#link("../sampling-distributions/")[標本分布のまとめ]に、分布どうしの関係は#link("../distribution-mandala/")[分布の曼陀羅]にまとめてある。

= 一覧

#table(
  columns: 4,
  [*分布*], [*何を表すか*], [*平均*], [*分散*],
  [ベルヌーイ分布$B(1, p)$], [1回の試行の成功・失敗], [$p$], [$p (1 - p)$],
  [二項分布$Bin(n, p)$], [$n$回中の成功回数], [$n p$], [$n p (1 - p)$],
  [ポアソン分布$Po(lambda)$], [一定時間に起こる稀な事象の回数], [$lambda$], [$lambda$],
  [幾何分布$G(p)$], [初めて成功するまでの失敗回数], [$frac(1 - p, p)$], [$frac(1 - p, p^2)$],
  [負の二項分布$N B(r, p)$], [$r$回成功するまでの失敗回数], [$frac(r (1 - p), p)$], [$frac(r (1 - p), p^2)$],
  [超幾何分布$Hyper(N, M, n)$], [非復元抽出での当たりの数], [$n M/N$], [$n M/N (1 - M/N) frac(N - n, N - 1)$],
  [一様分布$U(a, b)$], [区間内のどこでも同じ確からしさ], [$frac(a + b, 2)$], [$frac((b - a)^2, 12)$],
  [指数分布$Ex(lambda)$], [次の事象が起こるまでの待ち時間], [$1/lambda$], [$1/lambda^2$],
  [正規分布$N(mu, sigma^2)$], [多数の小さな誤差の和], [$mu$], [$sigma^2$],
)

= 離散型の分布

== ベルヌーイ分布

#motivation(title: "すべての離散分布の部品")[
  コイン投げの表・裏、製品の良・不良、賛成・反対など、*結果が2通りしかない試行*はいたるところにある。
  これを「成功なら$1$、失敗なら$0$」という確率変数で表しておけば、成功の*回数*は単に足し算で数えられる。
  二項分布・幾何分布・負の二項分布は、すべてこのベルヌーイ試行を繰り返して作られる。
]

#definition[
  $ Pr{X = 1} = p, wide Pr{X = 0} = 1 - p $
  このような確率変数$X$の分布を*ベルヌーイ分布*という。
]

#theorem(title: "性質")[
  平均$p$、分散$p (1 - p)$
]

#memo[
  - $X^2 = X$（$0$と$1$しかとらない）なので$EE[X^2] = p$。よって$Var[X] = p - p^2 = p (1 - p)$。
  - 分散$p (1 - p)$は$p = 1/2$のとき最大の$1/4$。「五分五分のときが一番ばらつく」。
]

== 二項分布

#motivation(title: "成功回数を数えたい")[
  成功確率$p$の試行を$n$回*独立に*繰り返したときの成功回数を知りたい。
  これは独立なベルヌーイ確率変数$n$個の和であり、その分布が二項分布である。
  世論調査で「$n$人中何人が賛成か」を考えるときの基本モデルになる。
]

#definition[
  $ Pr{X = k} = binom(n, k) p^k (1 - p)^(n - k) wide (k = 0, 1, dots, n) $
  で与えられる分布を*二項分布*といい、$Bin(n, p)$で表す。
]

#theorem(title: "性質")[
  - 平均$n p$、分散$n p (1 - p)$
  - *再生性*：独立に$X_1 tilde.op Bin(m, p)$、$X_2 tilde.op Bin(n, p)$なら$X_1 + X_2 tilde.op Bin(m + n, p)$
  - $n$が大きいとき、$N(n p, n p (1 - p))$で近似できる（目安：$n p >= 5$かつ$n (1 - p) >= 5$）
  - $n$が大きく$p$が小さい（$n p = lambda$が一定）とき、$Po(lambda)$で近似できる
]

#memo[
  - $binom(n, k)$は「$n$回のうちどの$k$回が成功か」の選び方、$p^k (1 - p)^(n - k)$は「その並び1通りの確率」。
  - 平均・分散はベルヌーイ分布の*$n$倍*。独立な和なので、平均も分散も足し算になる。
]

== ポアソン分布

#motivation(title: "「稀だが試行回数が多い」事象を数えたい")[
  1日の交通事故の件数や、1ページあたりの誤植の数を考える。
  事故が起こりうる機会は膨大だが、1回あたりの確率はとても小さい。
  これは二項分布$Bin(n, p)$で$n$を非常に大きく、$p$を非常に小さくした状況で、$n$も$p$も正確にはわからない。

  そこで*平均回数$lambda = n p$だけ*を固定して$n -> infinity$の極限をとると、$n$と$p$が消えて$lambda$だけで書ける分布が得られる。
  これがポアソン分布である。
]

#definition[
  $ Pr{X = k} = frac(lambda^k e^(-lambda), k!) wide (k = 0, 1, 2, dots) $
  で与えられる分布を*ポアソン分布*といい、$Po(lambda)$で表す。
]

#theorem(title: "性質")[
  - *平均＝分散＝$lambda$*
  - *再生性*：独立に$X_1 tilde.op Po(lambda_1)$、$X_2 tilde.op Po(lambda_2)$なら$X_1 + X_2 tilde.op Po(lambda_1 + lambda_2)$
  - $lambda$が大きいとき、$N(lambda, lambda)$で近似できる
]

#memo[
  - 二項分布の分散$n p (1 - p)$で$p -> 0$とすると$n p = lambda$。だから*平均も分散も$lambda$*。
  - 「1時間に平均$3$件なら、2時間では平均$6$件」というように、時間を伸ばすと$lambda$も比例して増える（再生性）。
  - 二項近似の目安：$n >= 50$程度で$p <= 0.1$程度。
]

== 幾何分布

#motivation(title: "初めて成功するまで待ちたい")[
  「当たりが出るまでくじを引き続ける」とき、何回はずれるかを知りたい。
  二項分布は「回数を決めて成功を数える」のに対し、幾何分布は「成功するまで続けて失敗を数える」という、*視点を逆にした*分布である。
]

#definition[
  成功確率$p$のベルヌーイ試行を繰り返し、初めて成功するまでの*失敗の回数*を$X$とするとき、
  $ Pr{X = k} = p (1 - p)^k wide (k = 0, 1, 2, dots) $
  この分布を*幾何分布*といい、$G(p)$で表す。
]

#theorem(title: "性質")[
  - 平均$frac(1 - p, p)$、分散$frac(1 - p, p^2)$
  - *無記憶性*：$Pr{X >= s + t mid(|) X >= s} = Pr{X >= t}$
]

#memo[
  - 確率が$p, p (1 - p), p (1 - p)^2, dots$と*等比数列（幾何数列）*で減るから「幾何」分布。
  - 成功確率$1/6$なら、平均$5$回はずれてから当たる（試行回数で数えれば平均$6$回目）。「平均$1/p$回目に成功」と覚えるとよい。
  - 無記憶性：「$10$回はずれた後でも、これから先の待ち回数の分布は最初と同じ」。くじに記憶はない。
]

#caution(title: "定義の流儀")[
  「初めて成功するまでの*試行回数*」$Y = X + 1$（$Y = 1, 2, dots$）で定義する本もある。
  その場合$Pr{Y = k} = p (1 - p)^(k - 1)$、平均$1/p$で、分散は同じ$frac(1 - p, p^2)$。
  問題文でどちらの定義かを必ず確認すること。
]

== 負の二項分布

#motivation(title: [$r$回成功するまで待ちたい])[
  幾何分布は「1回目の成功」までだった。これを「*$r$回目*の成功」まで待つように一般化したい。
  $r$回目の成功までの失敗回数は、「各成功までの失敗回数（幾何分布）」を$r$個足したものになる。
]

#definition[
  成功確率$p$のベルヌーイ試行を繰り返し、$r$回目の成功までの*失敗の回数*を$X$とするとき、
  $ Pr{X = k} = binom(r + k - 1, k) p^r (1 - p)^k wide (k = 0, 1, 2, dots) $
  この分布を*負の二項分布*といい、$N B(r, p)$で表す。
]

#theorem(title: "性質")[
  - 平均$frac(r (1 - p), p)$、分散$frac(r (1 - p), p^2)$
  - $r = 1$のとき幾何分布に一致する
  - 独立な$G(p)$を$r$個足すと$N B(r, p)$
]

#memo[
  - 平均・分散は幾何分布の*$r$倍*（独立な$r$個の和だから）。
  - $binom(r + k - 1, k)$は「最後の1回は必ず成功なので、それ以外の$r + k - 1$回のうちどの$k$回が失敗か」。
  - 名前の由来：二項定理を負の指数$(1 - q)^(-r)$に拡張した展開に、確率が現れることから。
]

== 超幾何分布

#motivation(title: "取り出したものを戻さない")[
  $N$個のうち$M$個が当たりの箱から$n$個を取り出すとき、当たりの数を知りたい。
  *取り出すたびに戻す*（復元抽出）なら毎回の確率は$M/N$で一定なので二項分布になる。
  しかし現実の抜き取り検査や世論調査では、同じものを2回選ばない（*非復元抽出*）。
  その正確な分布が超幾何分布である。
]

#definition[
  $ Pr{X = k} = frac(binom(M, k) binom(N - M, n - k), binom(N, n)) $
  で与えられる分布を*超幾何分布*といい、$Hyper(N, M, n)$で表す。
]

#theorem(title: "性質")[
  $p = M/N$とおくと
  - 平均$n p$
  - 分散$n p (1 - p) dot frac(N - n, N - 1)$
  - $N -> infinity$（$M/N = p$一定）のとき$Bin(n, p)$に近づく
]

#memo[
  - 平均は二項分布と同じ$n p$。
  - 分散は二項分布に*$frac(N - n, N - 1)$（有限母集団修正）*がかかって小さくなる。戻さないぶん、同じものを重複して数えず、ばらつきが減るから。
    詳しくは#link("../../finite-population-correction/")[有限母集団修正]を参照。
  - 母集団$N$が標本$n$に比べて十分大きければ、戻しても戻さなくてもほぼ同じなので二項分布で近似できる。
]

= 連続型の分布

== 一様分布

#motivation(title: "「どこでも同じ」を表したい")[
  ルーレットの止まる角度や、四捨五入による丸め誤差のように、*区間内のどの値も同じ程度に起こりやすい*状況を表したい。
  何の情報もないときの最も素朴なモデルでもあり、コンピュータで乱数を作るときの出発点にもなる。
]

#definition[
  $ f(x) = frac(1, b - a) wide (a <= x <= b) $
  で与えられる分布を*一様分布*といい、$U(a, b)$で表す。
]

#theorem(title: "性質")[
  平均$frac(a + b, 2)$、分散$frac((b - a)^2, 12)$
]

#memo[
  - 平均は区間の真ん中。
  - 分散の「$12$」は$U(0, 1)$の分散$integral_0^1 x^2 d x - (1/2)^2 = 1/3 - 1/4 = 1/12$から来ている。
  - 離散版（サイコロの目など）を*離散一様分布*という。$1, dots, n$の一様分布の平均は$frac(n + 1, 2)$、分散は$frac(n^2 - 1, 12)$。
]

== 指数分布

#motivation(title: "次に起こるまでの時間を測りたい")[
  ポアソン分布は「一定時間に*何回*起こるか」を数えた。
  同じ現象を「次に起こるまで*どれだけ待つか*」という時間の側から見たものが指数分布である。

  単位時間あたり平均$lambda$回起こるとき、時間$x$の間に1回も起こらない確率は、ポアソン分布$Po(lambda x)$で$0$回の確率$e^(-lambda x)$。
  これが「待ち時間が$x$を超える確率」$Pr{X > x}$なので、微分すると密度$lambda e^(-lambda x)$が得られる。
]

#definition[
  $ f(x) = lambda e^(-lambda x) wide (x >= 0) $
  で与えられる分布を*指数分布*といい、$Ex(lambda)$で表す。
]

#theorem(title: "性質")[
  - 平均$1/lambda$、分散$1/lambda^2$
  - $Pr{X > x} = e^(-lambda x)$
  - *無記憶性*：$Pr{X > s + t mid(|) X > s} = Pr{X > t}$
  - 独立な$Ex(lambda)$を$alpha$個足すと$Gamma(alpha, lambda)$
]

#memo[
  - 「1時間に平均$lambda$回」なら「平均$1/lambda$時間ごと」。*平均は$lambda$の逆数*。
  - 標準偏差$1/lambda$が平均と等しい。
  - 無記憶性：「$10$分待っても来ないバスは、あと何分待つかの分布が最初と同じ」。連続型で無記憶性をもつのは指数分布だけで、幾何分布の連続版にあたる。
  - 機械の故障までの時間や、窓口に客が来る間隔のモデルに使われる。
]

== 正規分布

#motivation(title: "多数の小さな要因の和")[
  身長や測定誤差は、無数の小さな要因が足し合わさって決まる。
  *中心極限定理*によれば、独立な確率変数をたくさん足すと、元の分布によらず和の分布はある決まった形に近づく。
  その「行き着く先」が正規分布であり、だからこそ自然界や統計の至るところに現れる。
  標本平均の分布が近似的に正規分布になることも、ここから説明できる。
]

#definition[
  $ f(x) = frac(1, sqrt(2 pi) sigma) exp(-frac((x - mu)^2, 2 sigma^2)) $
  で与えられる分布を*正規分布*といい、$N(mu, sigma^2)$で表す。
  $N(0, 1)$を*標準正規分布*という。
]

#theorem(title: "性質")[
  - 平均$mu$、分散$sigma^2$。$mu$を中心に左右対称
  - *標準化*：$X tilde.op N(mu, sigma^2)$なら$Z = frac(X - mu, sigma) tilde.op N(0, 1)$
  - *再生性*：独立に$X_i tilde.op N(mu_i, sigma_i^2)$なら$a X_1 + b X_2 tilde.op N(a mu_1 + b mu_2, a^2 sigma_1^2 + b^2 sigma_2^2)$
  - 標本平均：$N(mu, sigma^2)$からの大きさ$n$の標本について$overline(X) tilde.op N(mu, sigma^2 "/" n)$
]

#memo[
  - $mu plus.minus sigma$に約$68%$、$mu plus.minus 2 sigma$に約$95%$、$mu plus.minus 3 sigma$に約$99.7%$が入る。
  - 正確には$95%$は$mu plus.minus 1.96 sigma$。
  - 差$X_1 - X_2$の分散も*足し算*$sigma_1^2 + sigma_2^2$になる（$(-1)^2 = 1$なので）。
  - 二項分布・ポアソン分布・$t$分布など、多くの分布が極限で正規分布に近づく。
]

== 2変量正規分布

#motivation(title: "2つの量の関係ごと表したい")[
  身長と体重のように、2つの量が*互いに関係しながら*ばらつく状況を表したい。
  それぞれが正規分布に従うだけでなく、その「連動の強さ」まで含めたモデルが2変量正規分布である。
  回帰分析や相関係数の理論の土台になる。
]

#definition[
  $(X, Y)$が平均$(mu_X, mu_Y)$、分散$sigma_X^2, sigma_Y^2$、相関係数$rho$の*2変量正規分布*に従うとき、その同時確率密度関数は
  $
    f(x, y) = frac(1, 2 pi sigma_X sigma_Y sqrt(1 - rho^2)) exp[-frac(1, 2 (1 - rho^2)) {(frac(x - mu_X, sigma_X))^2 - 2 rho frac(x - mu_X, sigma_X) frac(y - mu_Y, sigma_Y) + (frac(y - mu_Y, sigma_Y))^2}]
  $
]

#theorem(title: "性質")[
  - 周辺分布はそれぞれ正規分布：$X tilde.op N(mu_X, sigma_X^2)$、$Y tilde.op N(mu_Y, sigma_Y^2)$
  - 共分散$Cov[X, Y] = rho sigma_X sigma_Y$
  - *$X$と$Y$が独立 $<==>$ $rho = 0$*
  - 条件付き分布も正規分布：
    $
      Y mid(|) X = x tilde.op N(mu_Y + rho frac(sigma_Y, sigma_X) (x - mu_X), thin sigma_Y^2 (1 - rho^2))
    $
]

#memo[
  - 条件付き平均$mu_Y + rho frac(sigma_Y, sigma_X) (x - mu_X)$は、まさに*回帰直線*。$x$がわかると$y$の予測は平均から$rho$倍だけ寄せて動く（平均への回帰）。
  - 条件付き分散$sigma_Y^2 (1 - rho^2)$は、$x$を知ったことで分散が$(1 - rho^2)$倍に減ることを表す。$rho^2$は*決定係数*。
  - 一般には「無相関でも独立とは限らない」が、2変量正規分布では*無相関なら独立*。ここはよく問われる。
]

= ポアソン過程：ポアソン分布と指数分布の関係

ポアソン分布と指数分布は、*同じ現象を「回数」と「時間」の両側から見たもの*である。
事象が単位時間あたり平均$lambda$回、互いに独立にランダムに起こる状況を*ポアソン過程*という（客の到着、電話の着信など）。
この設定からポアソン分布・指数分布を導出し、平均・分散・モーメント母関数を求める計算は#link("../poisson-exponential/")[ポアソン分布と指数分布の導出]にまとめてある。


#let count-and-gap = cetz.canvas(length: .8cm, {
  import cetz.draw: *

  let events = (0.3, 2.4, 2.6, 3.4, 4.1, 4.25, 4.9, 6.1, 7.05, 7.4, 9.2)
  let windows = 10
  let purple = rgb("#7c6fcd")
  let teal = rgb("#0e7490")
  let red = rgb("#dc2626")
  let axis = (paint: luma(110), thickness: .6pt)
  let small(body) = text(size: 7.5pt, body)
  let tiny(body) = text(size: 6.5pt, body)
  let title(body) = text(size: 9pt, weight: "bold", body)

  // 各区間の回数と、各間隔の長さ（右のグラフはこれを集計する）
  let counts = range(windows).map(k => events.filter(e => k <= e and e < k + 1).len())
  let starts = (0,) + events.slice(0, -1)
  let gaps = events.zip(starts).map(((e, s)) => e - s)
  // 長さ1の区間を丸ごと含む間隔＝その区間は0回
  let is-long(s, e) = calc.ceil(s) + 1 <= e

  // 上側：長さ1の区間ごとに回数を数える
  for k in range(windows) {
    let empty = counts.at(k) == 0
    rect(
      (k, 0),
      (k + 1, 1),
      fill: if empty { red.lighten(85%) } else if calc.even(k) { purple.lighten(88%) } else { purple.lighten(80%) },
      stroke: .4pt + white,
    )
    content((k + .5, 1.3), text(size: 9pt, weight: "bold", fill: if empty { red } else { purple }, str(counts.at(k))))
  }
  content((5, 2.05), title[① 長さ$1$の区間ごとに回数を数える → ポアソン分布])

  // 時間軸と事象
  line((0, 0), (10.6, 0), stroke: axis, mark: (end: ">", fill: luma(110)))
  content((10.75, 0), anchor: "west", small[時間])
  for k in range(windows + 1) {
    line((k, 0), (k, -.08), stroke: axis)
    content((k, -.12), anchor: "north", text(size: 6.5pt, fill: luma(110), str(k)))
  }
  for e in events {
    line((e, 0), (e, -1.15), stroke: (paint: luma(190), thickness: .4pt, dash: "dotted"))
  }
  for e in events {
    circle((e, 0), radius: .09, fill: black, stroke: none)
  }

  // 下側：事象と事象の間隔を測る
  for (i, (s, e)) in starts.zip(events).enumerate() {
    let long = is-long(s, e)
    let y = if calc.even(i) { -.75 } else { -1.15 }
    let col = if long { red } else { teal }
    line((s, y), (e, y), stroke: (paint: col, thickness: if long { 1.2pt } else { .8pt }), mark: (start: "|", end: "|"))
  }
  content((5, -1.45), anchor: "north", text(size: 7pt, fill: red)[赤：$0$回の区間を丸ごと含む長い間隔])
  content((5, -2.15), title[② 次の事象までの間隔を測る → 指数分布])

  let rx = 12.6

  // 右上：回数の度数分布（棒＝左のデータ、点＝理論 Po(1)）
  let ch = 3.2
  for k in range(5) {
    let x = rx + k * .5
    let obs = counts.filter(c => c == k).len() / windows
    let col = if k == 0 { red } else { purple }
    if obs > 0 {
      rect((x - .17, 0), (x + .17, obs * ch), fill: col.lighten(75%), stroke: .5pt + col)
    }
    circle((x, calc.exp(-1) / calc.fact(k) * ch), radius: .06, fill: black, stroke: none)
    content((x, -.1), anchor: "north", tiny(str(k)))
  }
  line((rx - .35, 0), (rx + 2.35, 0), stroke: axis)
  content((rx + 1, 1.95), small[→ 回数の分布])
  content((rx + 1, 1.55), tiny[棒：左の$10$区間　点：$Po(1)$])

  // 右下：間隔の度数分布（棒＝左のデータの密度、曲線＝理論 Ex(1)）
  let eb = -3.1
  let bw = .5
  let gh = 1.3
  line((rx - .35, eb), (rx + 2.35, eb), stroke: axis)
  for b in range(5) {
    let lo = b * bw
    let hi = lo + bw
    let n = gaps.filter(g => lo <= g and (g < hi or b == 4)).len()
    let dens = n / gaps.len() / bw
    let col = if lo >= 1 { red } else { teal }
    if n > 0 {
      rect((rx - .35 + lo, eb), (rx - .35 + hi, eb + dens * gh), fill: col.lighten(75%), stroke: .5pt + col)
    }
  }
  line(..range(0, 26).map(i => (rx - .35 + i / 10, eb + calc.exp(-i / 10) * gh)), stroke: 1.2pt + black)
  for x in (0, 1, 2) {
    content((rx - .35 + x, eb - .1), anchor: "north", tiny(str(x)))
  }
  content((rx + 1, eb + 2.2), small[→ 間隔の長さの分布])
  content((rx + 1, eb + 1.8), tiny[棒：左の$11$個の間隔　曲線：$Ex(1)$])
})

#let poisson-process = cetz.canvas(length: .8cm, {
  import cetz.draw: *

  let arrivals = (1.0, 2.4, 5.0, 5.7, 7.8)
  let departures = (3.6, 6.6)
  let t0 = 7.2
  let tmax = 8.6
  let purple = rgb("#7c6fcd")
  let green = rgb("#2a9d78")
  let axis = (paint: luma(110), thickness: .6pt)
  let arrow = (end: ">", fill: luma(110))
  let small(body) = text(size: 7.5pt, body)
  let title(body) = text(size: 9pt, weight: "bold", body)
  let bx = 10.2

  // 横向きの棒グラフ（確率関数）
  let bars(base, probs, scale, color) = {
    for (k, p) in probs.enumerate() {
      let y = base + k * .5
      rect((bx, y - .17), (bx + p * scale, y + .17), fill: color.lighten(85%), stroke: .5pt + color, radius: 1.5pt)
      content((bx - .15, y), anchor: "east", small[#k])
    }
  }

  // 上段：到着累計数 A(t)
  let base = 12
  let u = .55
  line((0, base), (9, base), stroke: axis, mark: arrow)
  line((0, base), (0, base + 3.6), stroke: axis, mark: arrow)
  content((9.2, base), anchor: "west", small[$t$])
  content((0, base + 3.9), anchor: "west", title[到着累計数 $A(t)$])

  let pts = ((0, base),)
  for (i, a) in arrivals.enumerate() {
    pts.push((a, base + i * u))
    pts.push((a, base + (i + 1) * u))
  }
  pts.push((tmax, base + arrivals.len() * u))
  line(..pts, stroke: 1.2pt + purple)

  let k0 = arrivals.filter(a => a < t0).len()
  line((t0, base), (t0, base + k0 * u), stroke: (paint: luma(150), thickness: .5pt, dash: "dashed"))
  circle((t0, base + k0 * u), radius: .08, fill: purple, stroke: none)
  content((t0, base - .1), anchor: "north", small[$t_0$])

  // λt0 = 3 のポアソン分布
  let lt = 3
  bars(base, range(7).map(k => calc.pow(lt, k) * calc.exp(-lt) / calc.fact(k)), 9, purple)
  content((bx - .3, base + 3.9), anchor: "west", title[$A(t_0) tilde.op Po(lambda t_0)$])

  // 中段：到着間隔 T_n
  let prev = 0
  for (i, a) in arrivals.enumerate() {
    let y = base - 1.2 - i * .55
    line((a, base), (a, y + .4), stroke: (paint: luma(170), thickness: .4pt, dash: "dashed"))
    rect((prev, y), (a, y + .4), fill: purple.lighten(85%), stroke: .5pt + purple, radius: 1.5pt)
    content(((prev + a) / 2, y + .2), small[$T_#(i + 1)$])
    prev = a
  }

  // 指数分布の密度
  let eb = 7.9
  line((bx, eb), (bx + 2.9, eb), stroke: axis)
  line((bx, eb), (bx, eb + 2.3), stroke: axis, mark: arrow)
  line(..range(0, 27).map(i => (bx + i / 10, eb + 2.1 * calc.exp(-1.5 * i / 10))), stroke: 1.2pt + purple)
  content((bx - .3, eb + 2.7), anchor: "west", title[到着間隔 $T_n tilde.op Ex(lambda)$])
  content((bx + 1.45, eb - .1), anchor: "north", small[間隔の長さ])

  // 下段：M/M/1 の系内人数 N(t)
  let nb = 2.6
  line((0, nb), (9, nb), stroke: axis, mark: arrow)
  line((0, nb), (0, nb + 3.2), stroke: axis, mark: arrow)
  content((9.2, nb), anchor: "west", small[$t$])
  content((0, nb + 4.1), anchor: "west", title[系内人数 $N(t)$])
  content((0, nb + 3.55), anchor: "west", small[↑ 到着（率$lambda$）　↓ サービス完了（率$mu$）])

  let events = (arrivals.map(a => (a, 1)) + departures.map(d => (d, -1))).sorted(key: e => e.at(0))
  let cnt = 0
  let npts = ((0, nb),)
  for (time, step) in events {
    npts.push((time, nb + cnt * u))
    cnt += step
    npts.push((time, nb + cnt * u))
  }
  npts.push((tmax, nb + cnt * u))
  line(..npts, stroke: 1.2pt + green)

  // ρ = 0.6 の幾何分布
  let r = .6
  bars(nb, range(6).map(k => (1 - r) * calc.pow(r, k)), 5, green)
  content((bx - .3, nb + 4.1), anchor: "west", title[$t -> infinity$での$N$の分布])
  content((bx - .3, nb + 3.55), anchor: "west", small[幾何分布 $(1 - rho) rho^n$])
})

#figure(caption: [同じ事象の列を「数える」か「測る」か（$lambda = 1$の例）], frame(count-and-gap))

時間軸上の黒い点が、事象の起こった時刻である。同じ点の列から

+ 長さ$1$の区間に区切って、区間ごとに*何回起こったか*を数えると、その回数はポアソン分布$Po(lambda)$に従う
+ 点と点の*間隔の長さ*を測ると、その長さは指数分布$Ex(lambda)$に従う

右側のグラフは、左の図から実際に数えた回数と、測った間隔の長さを集計したもの（棒）で、理論上の分布（点・曲線）とおおむね一致している。

赤に注目すると、$0$回の区間（$[1, 2)$、$[5, 6)$、$[8, 9)$）には、それぞれその区間を丸ごと含む長い間隔がある。「区間で$0$回」ということは「その区間をまたぐ長さ$1$以上の間隔がある」ということと同じである。
このように、*回数が少ないこと*と*間隔が長いこと*は同じ出来事の言い換えになっている。
理論上も、$Po(1)$で$0$回の確率と、$Ex(1)$で間隔が$1$より長い確率は、どちらも$e^(-1) approx 0.37$で等しい。

次の図は、同じ関係を累計回数のグラフで表し、さらに待ち行列への応用まで描いたものである。

#figure(caption: [ポアソン過程とM/M/1待ち行列], frame(poisson-process))

#theorem(title: "回数と間隔")[
  単位時間あたり平均$lambda$回のポアソン過程について、
  - 時刻$t$までの発生回数$A(t)$は$Po(lambda t)$に従う
  - 発生の間隔$T_1, T_2, dots$は互いに独立に$Ex(lambda)$に従う
  - $n$回目の発生時刻$S_n = T_1 + dots.c + T_n$は$Gamma(n, lambda)$に従う
]

この2つが表裏一体であることは、「時刻$t$までに1回も起こらない」という同じ出来事を2通りに書くとわかる。
$ Pr{A(t) = 0} = e^(-lambda t) = Pr{T_1 > t} $
左辺はポアソン分布$Po(lambda t)$で$0$回の確率、右辺は指数分布$Ex(lambda)$で待ち時間が$t$を超える確率である。
一般に「時刻$t$までに$n$回以上起こる」ことと「$n$回目が時刻$t$までに起こる」ことは同じなので
$ Pr{A(t) >= n} = Pr{S_n <= t} $
が成り立ち、ポアソン分布と$Gamma$分布もこの式で結ばれる。

#memo[
  - *数えればポアソン、測れば指数*。
  - グラフの縦方向（ある時刻での高さ）を見ればポアソン分布、横方向（段と段の間の長さ）を見れば指数分布。
  - 指数分布の無記憶性により、どの時点から観察を始めても「次の発生までの時間」は同じ$Ex(lambda)$に従う。
]

== 応用：M/M/1待ち行列

窓口が1つの待ち行列で、客の到着が率$lambda$のポアソン過程、1人あたりのサービス時間が率$mu$の指数分布に従うモデルを*M/M/1モデル*という。
到着で系内人数$N(t)$が$1$増え、サービス完了で$1$減る（図の下段）。

#theorem[
  $rho = lambda / mu < 1$のとき、十分時間が経つと系内人数$N$の分布は
  $ Pr{N = n} = (1 - rho) rho^n wide (n = 0, 1, 2, dots) $
  となる。これは成功確率$1 - rho$の幾何分布$G(1 - rho)$であり、平均系内人数は$frac(rho, 1 - rho)$。
]

#memo[
  - $rho = lambda / mu$は*窓口の混み具合*（利用率）。$rho$が$1$に近づくと平均系内人数$frac(rho, 1 - rho)$は急激に大きくなる。
  - 「$n$人いる確率」が$rho$倍ずつ等比数列で減っていくので幾何分布になる。
]

詳しい導出は#link("../../m-m-1/")[M/M/1モデル]を参照のこと。
