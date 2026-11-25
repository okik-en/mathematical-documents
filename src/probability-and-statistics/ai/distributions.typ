#import "/lib/utils.typ": *
#import "/lib/boxes.typ": *

#let document-config = (
  title: "標本分布のまとめ",
  description: "Gamma分布、chi^2分布、t分布、F分布の定義と覚え方をまとめたページ。",
  author: "Claude",
  keywords: ("統計検定", "標本分布"),
)

#show: previewer(document-config)

#link("../../sampling-distribution/")[標本分布]のページに登場する4つの分布について、定義・性質・覚え方を短くまとめる。
導出の詳細は元のページを参照のこと。

= 全体像

4つの分布は、すべて*標準正規分布$N(0, 1)$から組み立てられる*。

#memo(title: "組み立ての流れ")[
  + $N(0, 1)$を*2乗して足す*と$chi^2$分布
  + $N(0, 1)$を*$sqrt(chi^2 "/ 自由度")$で割る*と$t$分布
  + *$chi^2 "/ 自由度"$同士の比*をとると$F$分布
  + $chi^2$分布は$Gamma$分布の特別な場合

  「自由度で割る」のは、平均を$1$にそろえて大きさを比べやすくするためと覚えるとよい（$EE[chi^2(n)] = n$なので$chi^2(n) "/" n$の平均は$1$）。
]

#table(
  columns: 5,
  [*分布*], [*作り方*], [*平均*], [*分散*], [*主な用途*],
  [$Gamma(alpha, lambda)$], [指数分布の拡張], [$alpha/lambda$], [$alpha/lambda^2$], [待ち時間],
  [$chi^2(n)$], [$Z_1^2 + dots.c + Z_n^2$], [$n$], [$2 n$], [母分散・適合度・独立性の検定],
  [$t(n)$], [$frac(Z, sqrt(X "/" n))$], [$0$], [$frac(n, n - 2)$], [母平均の検定（分散未知）],
  [$F(m, n)$], [$frac(X "/" m, Y "/" n)$], [$frac(n, n - 2)$], [（略）], [分散の比・分散分析・回帰],
)

ここで$Z, Z_i tilde.op N(0, 1)$、$X tilde.op chi^2(m)$（$t$分布の行では$chi^2(n)$）、$Y tilde.op chi^2(n)$で、すべて独立とする。
$t$分布の分散は$n > 2$、$F$分布の平均は$n > 2$のときに存在する。

= $Gamma$分布

#motivation(title: "待ち時間を足し合わせたい")[
  指数分布$lambda e^(-lambda x)$は、「平均して単位時間に$lambda$回起こる事象が、*1回*起こるまでの待ち時間」の分布だった。
  では「*$alpha$回*起こるまでの待ち時間」はどう分布するだろうか。

  これは独立な指数分布$alpha$個の和であり、計算すると密度は$x^(alpha - 1) e^(-lambda x)$に比例する形になる。
  この形は$alpha$が整数でなくても意味をもち、全体を$1$にする定数がちょうど$Gamma$関数で書ける。
  そこで$alpha$を正の実数に広げたものを$Gamma$分布と定義する。

  $alpha$を半整数（$1/2, 3/2, dots$）まで許しておくと、後で$chi^2$分布をその特別な場合として扱えるようになる。
]

#definition[
  $alpha > 0$、$lambda > 0$について、確率密度関数
  $ f(x; alpha, lambda) = frac(lambda^alpha, Gamma(alpha)) x^(alpha - 1) e^(-lambda x) wide (x > 0) $
  で与えられる分布を*$Gamma$分布*といい、$Gamma(alpha, lambda)$で表す。
]

#theorem(title: "性質")[
  - 平均$alpha/lambda$、分散$alpha/lambda^2$
  - $alpha = 1$のとき指数分布$lambda e^(-lambda x)$に一致する
  - *再生性*：独立に$X_1 tilde.op Gamma(alpha_1, lambda)$、$X_2 tilde.op Gamma(alpha_2, lambda)$なら$X_1 + X_2 tilde.op Gamma(alpha_1 + alpha_2, lambda)$
]

#memo[
  - $alpha$は「何回分の待ち時間を足したか」、$lambda$は「単位時間あたりに起こる回数」。
    指数分布（$1$回分の待ち時間）を$alpha$回分足したものが$Gamma(alpha, lambda)$だと思えば、平均$alpha/lambda$は「$1$回あたり$1/lambda$の待ち時間 × $alpha$回」として自然に出てくる。
  - $Gamma$関数は「階乗の一般化」：$Gamma(n + 1) = n!$、$Gamma(1/2) = sqrt(pi)$。
]

#caution[
  再生性が使えるのは*$lambda$が等しいとき*だけである。
]

= $chi^2$分布

#motivation(title: "ばらつき・ずれの大きさを測りたい")[
  平均は$overline(X)$という*1次式*で推定でき、その分布は正規分布で済んだ。
  しかし*分散（ばらつき）*を推定しようとすると、$sum (X_i - overline(X))^2$のような*2乗の和*が必ず出てくる。

  各項を標準化すると、2乗の和は「標準正規分布に従う変数の2乗の和」になる。
  そこで、この*$Z_1^2 + dots.c + Z_n^2$の分布*さえ調べておけば、母分散についての推定・検定がすべてできる。
  これが$chi^2$分布を定義する理由である。

  同じ発想で、適合度検定や独立性の検定の「観測と期待の*ずれの2乗の和*」も$chi^2$分布で評価できる。
]

#definition[
  独立な$Z_1, dots, Z_n tilde.op N(0, 1)$について、
  $ X = Z_1^2 + Z_2^2 + dots.c + Z_n^2 $
  が従う分布を自由度$n$の*$chi^2$分布*といい、$chi^2(n)$で表す。
  上側$100 alpha%$点を$chi^2_n (alpha)$と書く。
]

#theorem(title: "性質")[
  - 平均$n$、分散$2 n$
  - $chi^2(n) = Gamma(n/2, 1/2)$
  - *再生性*：独立に$X_1 tilde.op chi^2(m)$、$X_2 tilde.op chi^2(n)$なら$X_1 + X_2 tilde.op chi^2(m + n)$
  - 正規母集団$N(mu, sigma^2)$からの標本について、不偏分散$U^2$を使った
    $ frac((n - 1) U^2, sigma^2) tilde.op chi^2(n - 1) $
    が成り立つ（$mu$を$overline(X)$で推定したぶん、自由度が$1$減る）。
]

#memo[
  - *「二乗の和」なので必ず$0$以上*で、右に裾が長い。自由度が大きくなるほど左右対称に近づく。
  - $EE[Z_i^2] = Var[Z_i] = 1$なので、$n$個足すと平均は$n$。「平均＝自由度」と覚える。
  - 分散は「$2 times$自由度」。
  - 左右非対称なので、両側検定では*下側と上側で別々の値*（$chi^2_n (1 - alpha/2)$と$chi^2_n (alpha/2)$）を分布表から読む。
]

= $t$分布

#motivation(title: "母分散がわからないまま平均を調べたい")[
  母平均の推定・検定には$Z = frac(overline(X) - mu, sigma "/" sqrt(n))$を使えばよいが、これには*母標準偏差$sigma$*が必要である。
  現実には$sigma$がわかっていることはほとんどない。

  そこで$sigma$を標本から計算した$U$で置き換えると、
  $ frac(overline(X) - mu, U "/" sqrt(n)) = frac(Z, sqrt(frac((n - 1) U^2 "/" sigma^2, n - 1))) $
  となり、*分子は$N(0, 1)$、分母は$sqrt(chi^2(n - 1) "/" (n - 1))$*という形になる（しかも正規母集団なら$overline(X)$と$U^2$は独立）。
  未知の$sigma$は分子と分母で約分されて消えている。

  そこで「$N(0, 1)$を独立な$sqrt(chi^2 "/" "自由度")$で割ったもの」を新しい分布として定義すれば、$sigma$を知らなくても母平均を扱える。
  これが$t$分布である。
  ビール会社で少ない標本から品質管理をしていたゴセットが、「スチューデント」というペンネームで発表した。
]

#definition[
  独立な$Z tilde.op N(0, 1)$、$X tilde.op chi^2(n)$について、
  $ T = frac(Z, sqrt(X "/" n)) $
  が従う分布を自由度$n$の*$t$分布*といい、$t(n)$で表す。
  上側$100 alpha%$点を$t_n (alpha)$と書く。
]

#theorem(title: "性質")[
  - $0$を中心に左右対称（$n > 1$で平均$0$）、$n > 2$で分散$frac(n, n - 2)$
  - $n -> infinity$で$N(0, 1)$に近づく
  - 正規母集団からの標本について、*スチューデントの$t$統計量*
    $ T = frac(overline(X) - mu, U "/" sqrt(n)) tilde.op t(n - 1) $
  - $T tilde.op t(n)$なら$T^2 tilde.op F(1, n)$
]

#memo[
  - $Z$統計量$frac(overline(X) - mu, sigma "/" sqrt(n))$の*$sigma$を$U$に置き換えたもの*が$t$統計量。
    推定した$U$がぶれるぶん、$N(0, 1)$より*裾が重い*（極端な値が出やすい）。
  - そのため同じ有意水準でも$t_n (alpha) > z(alpha)$。例：$t_(15)(0.025) approx 2.131 > 1.960 approx z(0.025)$。
  - 左右対称なので下側の点は$-t_n (alpha)$でよい。
  - 自由度が$30$程度を超えると、ほぼ正規分布として扱える。
]

= $F$分布

#motivation(title: "2つのばらつきを比べたい")[
  2つの母集団のばらつきが同じかどうかを調べたい。
  分散の大きさを比べるなら、*差*より*比*のほうが自然である（単位に依存せず、「何倍か」で比べられる）。

  正規母集団では$U_1^2 = sigma_1^2 dot frac(chi^2(m - 1), m - 1)$、$U_2^2 = sigma_2^2 dot frac(chi^2(n - 1), n - 1)$と書けるので、比をとると
  $ U_1^2 / U_2^2 = sigma_1^2 / sigma_2^2 dot frac(chi^2(m - 1) "/" (m - 1), chi^2(n - 1) "/" (n - 1)) $
  となる。$sigma_1^2 = sigma_2^2$なら未知の分散は約分されて消え、*「$chi^2$ / 自由度」同士の比*だけが残る。
  そこでこの比の分布を$F$分布と定義する。

  各$chi^2$を自由度で割っておくのは、どちらも平均がおよそ$1$になり、「比が$1$に近いか」で判断できるようにするため。
  分散分析で「群間のばらつき」と「群内のばらつき」を比べるのも同じ発想で、名前の$F$は分散分析を考案したフィッシャー（Fisher）に由来する。
]

#definition[
  独立な$X tilde.op chi^2(m)$、$Y tilde.op chi^2(n)$について、
  $ F = frac(X "/" m, Y "/" n) $
  が従う分布を自由度$(m, n)$の*$F$分布*といい、$F(m, n)$で表す。
  上側$100 alpha%$点を$F^m_n (alpha)$と書く。
]

#theorem(title: "性質")[
  - 必ず$0$以上で、右に裾が長い
  - $F tilde.op F(m, n)$なら$1/F tilde.op F(n, m)$
  - 上の性質から
    $ F^m_n (1 - alpha) = frac(1, F^n_m (alpha)) $
  - 正規母集団からの2標本について
    $ frac(U_1^2 "/" sigma_1^2, U_2^2 "/" sigma_2^2) tilde.op F(m - 1, n - 1) $
]

#memo[
  - *「分散の比」の分布*。$sigma_1^2 = sigma_2^2$なら$U_1^2 "/" U_2^2$は$1$の近くに来るはず。
  - 自由度は*（分子の自由度, 分母の自由度）*の順。分子と分母をひっくり返したら、自由度もひっくり返る。
  - 分布表には上側の点しか載っていないことが多い。下側の点は「逆数をとって自由度を入れ替える」で求める。
  - $t(n)^2 = F(1, n)$：$t$統計量の2乗は分子の自由度$1$の$F$統計量。回帰の$t$検定と$F$検定が一致する理由になる。
]

= どの検定でどの分布を使うか

#table(
  columns: 2,
  [*分布*], [*使う検定*],
  [$N(0, 1)$],
  [
    #link("../mean-test/")[母平均の検定]（分散既知）、#link("../proportion-test/")[母比率の検定]、#link("../mean-difference-test/")[母平均の差の検定]（分散既知）、#link("../proportion-difference-test/")[母比率の差の検定]
  ],

  [$t$分布],
  [
    #link("../mean-test/")[母平均の検定]（分散未知）、#link("../mean-difference-test/")[母平均の差の検定]（分散未知）、#link("../regression-estimation/")[回帰係数の推定]、#link("../regression-test/")[回帰係数の検定]
  ],

  [$chi^2$分布],
  [
    #link("../variance-test/")[母分散の検定]、#link("../goodness-of-fit-test/")[適合度検定]、#link("../independence-test/")[独立性の検定]
  ],

  [$F$分布],
  [
    #link("../variance-ratio-test/")[母分散の比の検定]、#link("../anova/")[一元配置分散分析]、#link("../regression-test/")[回帰式全体の検定]
  ],
)
