#import "/templates/template.typ": *
#import "/templates/html.typ": *
#import "/templates/consts.typ": *
#show: template

#set document(
  title: "標本分布",
  description: "chi^2分布やt分布、F分布に関してまとめたページ。",
  author: okik-en-data.authors.salty-lemon,
)

#let Var = math.op("Var")

#show: html-init

#title()
#author()

#outline()

= $Gamma$分布

== $Gamma$関数

$Gamma$関数は$alpha > 0$で以下のように定義される関数である。
$ Gamma(alpha) = integral_0^infinity t^(alpha - 1) e^(-t) d t $

$Gamma$関数は以下の性質を満たす。

+ $Gamma(1) = 1$、$Gamma(1/2) = sqrt(pi)$
+ $Gamma(alpha + 1) = alpha Gamma(alpha)$

これらより、$n in NN$について$Gamma(n + 1) = n!$が言える。

次のように覚えておいてもよいだろう。
$ integral_0^infinity t^n e^(-t) d t = n! $

== 指数分布と$Gamma$分布

$lambda > 0$について、指数分布の確率密度関数は次式で与えられた。
$ f(x; lambda) = lambda e^(-lambda x) wide (x > 0) $

これをパラメータ$alpha > 0$により拡張した次の確率密度関数で与えられる分布を*$Gamma$分布*といい、$Gamma(alpha, lambda)$で表す。
$ f(x; alpha, lambda) = frac(lambda^alpha, Gamma(alpha)) x^(alpha - 1) e^(-lambda x) wide (x > 0) $

ただし、$alpha -> 1$とすれば指数分布に一致することに留意せよ。

== $Gamma$分布の再生性

$Gamma$分布に従う確率変数$X tilde.op Gamma(alpha, lambda)$を考える。

いま、$Gamma$関数の定義式において$t = nu x thick (==> d t = nu d x)$とおくことで
$
  Gamma(alpha) = integral_0^infinity (nu x)^(alpha - 1) e^(-nu x) nu d x = nu^alpha integral_0^infinity x^(alpha - 1) e^(-nu x) d x
$
が得られ、これにより$t < lambda$についてそのモーメント母関数は
$
  M_X (t; alpha, lambda) & = integral_0^infinity e^(t x) frac(lambda^alpha, Gamma(alpha)) x^(alpha - 1) e^(-lambda x) d x \
                         & = frac(lambda^alpha, Gamma(alpha)) integral_0^infinity x^(alpha - 1) e^(-(lambda - t) x) d x \
                         & = frac(lambda^alpha, Gamma(alpha)) frac(Gamma(alpha), (lambda - t)^alpha) \
                         & = (frac(lambda, lambda - t))^alpha
$
と書ける。

この式から、$X_1$および$X_2$が独立であれば
$
  X_1 tilde.op Gamma(alpha_1, lambda) and X_2 tilde.op Gamma(alpha_2, lambda) ==> X_1 + X_2 tilde.op Gamma(alpha_1 + alpha_2, lambda)
$
が成り立つことがわかる。
この性質を$Gamma$分布の*再生性*という。

= $chi^2$分布

== $chi^2$分布の定義

独立な標本$Z_1, dots, Z_n$がそれぞれ標準正規分布$N(0, 1)$に従うととする。
このとき、新たな確率変数$X = sum_(i = 1)^n Z_i^2$の従う分布を自由度$n$の*$chi^2$分布*（chi-squared distribution）といい、$chi^2(n)$で表す。

また、自由度$n$の$chi^2$分布について、その上側$alpha$点を$z_n (alpha)$で表すものとする。

== $chi^2$分布の再生性

$chi^2(n)$は$Gamma(n/2, 1/2)$と一致することが知られている。
数学的帰納法による略証を以下に示す。

+ $Z tilde.op N(0, 1)$とすれば、$X = Z^2$は$chi^2(1)$に従い、また$x >= 0$について
  $ X <= x <==> Z^2 <= x <==> abs(Z) <= sqrt(x) <==> -sqrt(x) <= Z <= sqrt(x) $
  であるから、その分布関数$F(x)$について
  $ F(x) = Pr{X <= x} = Pr{-sqrt(x) <= Z <= sqrt(x)} = 1/sqrt(2 pi) integral_(-sqrt(x))^sqrt(x) e^(-z^2/2) d z $
  が得られ、ゆえに確率密度関数$f(x) = F'(x)$は
  $ f(x) = frac(d, d x) F(x) = 1/sqrt(2 pi x) e^(-x/2) $
  と表せる。これは$Gamma(1/2, 1/2)$に一致する。
+ 任意の$k in NN$をとり、$chi^2(k)$が$Gamma(k/2, 1/2)$に一致するものとする。
  $Z_1, dots, Z_(k + 1) tilde.op N(0, 1)$とすれば、$X = Z_1^2 + dots.c + Z_k^2 + Z_(k + 1)^2$は$chi^2(k + 1)$に従う。
  ここで$X' = Z_1^2 + dots.c + Z_k^2$は$Gamma(k/2, 1/2)$に従い、$Z_(k + 1)^2$は$Gamma(1/2, 1/2)$に従うため、$Gamma$分布の再生性により$X = X' + Z_(k + 1)^2$は$Gamma((k + 1)/2, 1/2)$に従う。

これにより、$chi^2$分布は$Gamma$分布と同じように再生性をもつことが示された。

= $t$分布

== $t$分布の定義

独立な確率変数$X tilde.op chi^2(n)$、$Z tilde.op N(0, 1)$について、新たな確率変数$T = frac(Z, sqrt(frac(X, n, style: "horizontal")))$が従う分布を自由度$n$の*$t$分布*（t-distribution）といい、$t(n)$で表す。

また、自由度$n$の$t$分布について、その上側$alpha$点を$t_n (alpha)$で表すものとする。

= $F$分布

== $F$分布の定義

独立な確率変数$X tilde.op chi^2(m)$、$Y tilde.op chi^2(n)$について、新たな確率変数$F = frac(frac(X, m, style: "horizontal"), frac(Y, n, style: "horizontal"))$が従う分布を自由度$(m, n)$の*$F$分布*（F-distribution）といい、$F(m, n)$で表す。

また、自由度$(m, n)$の$F$分布について、その上側$alpha$点を$F^m_n (alpha)$で表すものとする。

== $F$分布の交換性

$0 < alpha < 1$について、$F tilde.op F(n, m)$とすれば
$ alpha = Pr{F >= F^n_m (alpha)} = Pr{1/F <= 1/(F^n_m (alpha))} = 1 - Pr{1/F >= 1/(F^n_m (alpha))} $
であり、ゆえに
$ Pr{1/F >= 1/(F^n_m (alpha))} = 1 - alpha $
である。ここで定義から$1/F tilde.op F(m, n)$であり
$ F^m_n (1 - alpha) = 1/(F^n_m (alpha)) $
が示された。

= 統計量

== 不偏分散に関する統計量

$X_1, dots, X_n$を$N(mu, sigma^2)$からの無作為標本とする。

標本平均$overline(X) = 1/n sum_(i = 1)^n X_i$と不偏分散$U^2 = frac(1, n - 1) sum_(i = 1)^n (X_i - overline(X))^2$が既知であるとする。

いま、標本平均$overline(X)$について
$ sum_(i = 1)^n (X_i - overline(X)) = sum_(i = 1)^n X_n - n overline(X) = 0 $
である（すなわち、$X_i - overline(X)$の自由度は高々$n - 1$である）ことに注意して次を議論する。

=== $chi^2$変量

標本$X_1, dots, X_n$について、これらを標準化した変量
$ Z_i = frac(X_i - mu, sigma) quad (i = 1, dots, n) $
を考えると、それぞれ$Z_i tilde.op N(0, 1)$であるから、統計量$W$を
$ W = sum_(i = 1)^n Z_i^2 $
で定義すれば、$W$は自由度$n$の$chi^2$分布に従う。

=== $Z$統計量

標本平均$overline(X)$について、これを標準化した統計量
$ Z = frac(overline(X) - mu, frac(sigma, sqrt(n), style: "horizontal")) $
を考えると、$Z tilde.op N(0, 1)$であるから、$Z^2$は自由度$1$の$chi^2$分布に従う。

=== $chi^2$統計量

標本$X_1, dots, X_n$について、これらを「標本平均$overline(X)$により」標準化した変量
$
  Z'_i = frac(X_i - overline(X), sigma) quad (i = 1, dots, n)
$
を考える。
これについて新たな統計量
$ Y = sum_(i = 1)^n Z'_i^2 = frac((n - 1) U^2, sigma^2) $
を考えると、
$
  Y & = sum_(i = 1)^n (frac(X_i - overline(X), sigma))^2 \
  & = sum_(i = 1)^n [frac((X_i - mu) - (overline(X) - mu), sigma)]^2 \
  & = sum_(i = 1)^n (frac(X_i - mu, sigma))^2 - 2 frac(overline(X) - mu, sigma^2) underbracket(sum_(i = 1)^n (X_i - mu), = 0) + n (frac(overline(X) - mu, sigma))^2 \
  & = sum_(i = 1)^n (frac(X_i - mu, sigma))^2 - (frac(overline(X) - mu, frac(sigma, sqrt(n), style: "horizontal")))^2 \
  & = W - Z^2
$
を得る。
$W$と$Z^2$は独立だから、$chi^2$分布の再生性より、$Y = W - Z^2$は自由度$n - 1$の$chi^2$分布に従う。

=== スチューデントの$t$統計量

$Z$統計量は母分散$sigma^2$を既知とする統計量であるが、必ずしも既知とは限らないため、代わりに不偏分散$U^2$を用いた別の統計量
$
  T = frac(overline(X) - mu, frac(U, sqrt(n), style: "horizontal"))
$
を考えると、
$
  T = frac(frac(overline(X) - mu, frac(sigma, sqrt(n), style: "horizontal")), sqrt(frac(frac((n - 1) U^2, sigma^2), n)), style: "horizontal") = frac(Z, sqrt(frac(Y, n, style: "horizontal")))
$
より$Z tilde.op N(0, 1)$と$Y tilde.op chi^2(n - 1)$は独立であり、定義より$T$は自由度$n - 1$の$t$分布に従う。

この統計量$T$は*スチューデントの$t$統計量*（Student's t-statistic）と呼ばれる。

== ピアソンの$chi^2$統計量

事象$A_1, dots, A_k$は互いに排反で、各事象が起こる確率を$p_i$とし、$n$個の標本を抽出したとき$A_i$が出現した回数を$X_i$とする。

$n$が十分大きいとき、ピアソンの定理（Pearson's theorem）によれば、統計量
$ T = sum_(i = 1)^k frac((X_i - n p_i)^2, n p_i) $
は自由度$k - 1$の$chi^2$分布に従うことが知られる。

この統計量$T$は*ピアソンの$chi^2$統計量*（Pearson's chi-squared statistic）と呼ばれる。

== 2標本問題

$N(mu_1, sigma_1^2)$に従う無作為標本$X_1, dots, X_m$と$N(mu_2, sigma_2^2)$に従う無作為標本$Y_1, dots, Y_n$があり、それぞれは独立とする。
それぞれの標本平均を$overline(X)$と$overline(Y)$、不偏分散を$U_1^2$と$U_2^2$とする。

=== 母分散が既知のとき

それぞれの標本平均は、$overline(X)$は$N(mu_1, sigma_1^2/m)$に、$overline(Y)$は$N(mu_2, sigma_2^2/n)$に従うため、差$overline(D) = overline(X) - overline(Y)$は正規分布の再生性より$N(mu_1 - mu_2, sigma_1^2/m + sigma_2^2/n)$に従う。
すなわち統計量
$
  Z = frac(overline(D) - (mu_1 - mu_2), sqrt(frac(sigma_1^2, m, style: "horizontal") + frac(sigma_2^2, n, style: "horizontal")))
$
は標準正規分布$N(0, 1)$に従う。

=== 母分散が未知で等しいとき

それぞれの$chi^2$統計量$frac((m - 1) U_1^2, sigma^2)$と$frac((n - 1) U_2^2, sigma^2)$はそれぞれ独立に$chi^2(m - 1)$および$chi^2(n - 1)$に従うため、$chi^2$分布の再生性より
$
  Y = frac((m - 1) U_1^2, sigma^2) + frac((n - 1) U_2^2, sigma^2) = frac(m + n - 2, sigma^2) dot underbracket(frac((m - 1) U_1^2 + (n - 1) U_2^2, m + n - 2), eq.delta U^2) = frac((m + n - 2) U^2, sigma^2)
$
は$chi^2(m + n - 2)$に従う。
また$Z = frac(overline(D) - (mu_1 - mu_2), sigma sqrt(frac(1, m, style: "horizontal") + frac(1, n, style: "horizontal")))$は$N(0, 1)$に従うため、$Y$と$Z$が独立であることから、統計量
$
  T = frac(Z, sqrt(frac(Y, m + n - 2)), style: "horizontal") = Z dot frac(sigma, U) = frac(overline(D) - (mu_1 - mu_2), U sqrt(frac(1, m, style: "horizontal") + frac(1, n, style: "horizontal")))
$
は$t(m + n - 2)$に従う。

=== 母分散が未知で等しくないとき

$sigma_1^2$の代わりに$U_1^2$、$sigma_2^2$の代わりに$U_2^2$を用いるという*ウェルチの近似法*（Welch's approximation）により、統計量
$
  T_0 = frac(overline(D) - (mu_1 - mu_2), sqrt(frac(U_1^2, m, style: "horizontal") + frac(U_2^2, n, style: "horizontal")))
$
は、近似的に自由度が
$
  c = frac((frac(U_1^2, m, style: "horizontal") + frac(U_2^2, n, style: "horizontal"))^2, frac((frac(U_1^2, m, style: "horizontal"))^2, m - 1) + frac((frac(U_2^2, n, style: "horizontal"))^2, n - 1))
$
に最も近い自然数$k$の$t$分布$t(k)$に従うことが知られている。

=== 母平均が未知で母分散が既知のとき

それぞれの$chi^2$統計量$frac((m - 1) U_1^2, sigma_1^2)$と$frac((n - 1) U_2^2, sigma_2^2)$はそれぞれ独立に$chi^2(m - 1)$および$chi^2(n - 1)$に従うため、$F$分布の定義より
$
  F = frac(frac(frac((m - 1) U_1^2, sigma_1^2), (m - 1), style: "horizontal"), frac(frac((n - 1) U_2^2, sigma_2^2), (n - 1), style: "horizontal")) = frac(frac(U_1^2, sigma_1^2, style: "horizontal"), frac(U_2^2, sigma_2^2, style: "horizontal"))
$
は$F(m - 1, n - 1)$に従う。

= 検定

== $chi^2$検定

=== 分散の検定

平均$mu$、分散$sigma^2$がともに未知である正規分布$N(mu, sigma^2)$の母分散$sigma^2$の検定を考える。

いま、「$sigma^2 = sigma_0^2$」を仮定すると、不偏分散$U^2$について$chi^2$統計量
$ Y = sum_(i = 1)^n (frac(X_i - overline(X), sigma))^2 = frac((n - 1) U^2, sigma_0^2) $
は自由度$n - 1$の$chi^2$分布$chi^2 (n - 1)$に従い、とくに有意水準を$alpha$とすれば
/ 両側検定: $Y in {y mid(|) y < chi^2_(n - 1) (1 - alpha/2), y > chi^2_(n - 1) (alpha/2)} ==> sigma^2 != sigma_0^2$
/ 右側検定: $Y in {y mid(|) y > chi^2_(n - 1) (alpha)} ==> sigma^2 > sigma_0^2$
/ 左側検定: $Y in {y mid(|) y < chi^2_(n - 1) (1 - alpha)} ==> sigma^2 < sigma_0^2$
がいえる。

=== 適合度の検定

母集団が互いに排反な$k$個の事象$A_1, dots, A_k$に分割されているとき、各事象における母比率$P(A_1), dots, P(A_k)$の検定を考える。

いま、「$forall i in {1, dots, k} colon P(A_i) = p_i$」を仮定すると、十分大きい$n$でピアソンの$chi^2$統計量
$ T = sum_(i = 1)^k frac((X_i - n p_i)^2, n p_i) $
は自由度$k - 1$の$chi^2$分布に従い、とくに有意水準を$alpha$とすれば
$ T in {t mid(|) t > chi^2_(k - 1) (alpha)} ==> exists i in {1, dots, k} colon P(A_i) != p_i $
がいえる（適合しない場合はズレが大きくなるため）。

=== 独立性の検定

母集団における2つの性質$A$および$B$がそれぞれ$k$個、$l$個の排反な階級$A_1, dots, A_k$および$B_1, dots, B_l$に分割されているとき、2つの性質$A$と$B$が独立であるかどうかの検定を考える。

いま、「性質$A$と$B$は独立である」ことを仮定する。このとき、
$ P(A_i) approx q_i = 1/n sum_(i = 1)^l n_(i, j), wide P(B_j) approx r_j = 1/n sum_(j = 1)^k n_(i, j) $
とおけば、性質の独立性より
$ P(A_i inter B_j) approx p_(i j) = q_i r_j $
であり、十分大きい$n$についてピアソンの$chi^2$統計量
$
  T = sum_(i = 1)^k sum_(j = 1)^l frac((n_(i j) - n p_(i j))^2, n p_(i j))
$
は自由度$(k - 1)(l - 1)$の$chi^2$分布に従い、とくに有意水準を$alpha$とすれば
$
  T in {t mid(|) t > chi^2_((k - 1)(l - 1)) (alpha)} ==> A "と" B "は独立でない"
$
がいえる。

== $t$検定

=== 母平均の検定（母分散未知）

平均$mu$、分散$sigma^2$がともに未知である正規分布$N(mu, sigma^2)$の母平均$mu$の検定を考える。

いま、「$mu = mu_0$」を仮定すると、標本平均$overline(X)$についてスチューデントの$t$統計量
$ T = frac(overline(X) - mu_0, frac(U, sqrt(n), style: "horizontal")) $
は自由度$n - 1$の$t$分布に従い、とくに有意水準を$alpha$とすれば
/ 両側検定: $T in {t mid(|) abs(t) > t_(n - 1) (alpha/2)} ==> mu != mu_0$
/ 右側検定: $T in {t mid(|) t > t_(n - 1) (alpha)} ==> mu > mu_0$
/ 左側検定: $T in {t mid(|) t < -t_(n - 1) (alpha)} ==> mu < mu_0$
がいえる。

この手法は、サイズがともに$n$である2つの標本を比較する場合にも応用できる。

平均$mu_1$、$mu_2$、分散$sigma_1^2$、$sigma_2^2$がともに未知である正規分布$N(mu_1, sigma_1^2)$および$N(mu_2, sigma_2^2)$の母平均$mu_1$と$mu_2$の検定を考えると、$mu = mu_1 - mu_2$とすることで等平均の検定を行うことができる。

=== 等平均の検定（母分散未知）

平均$mu_1$、$mu_2$、分散$sigma_1^2$、$sigma_2^2$がともに未知である正規分布$N(mu_1, sigma_1^2)$および$N(mu_2, sigma_2^2)$の母平均$mu_1$と$mu_2$の検定を考える。

+ 「$sigma_1^2 = sigma_2^2$」が既知であるとする。
  「$mu_1 = mu_2$」を仮定すると、サイズが$m$、$n$である各標本の平均$overline(X)$および$overline(Y)$について統計量
  $
    T = frac(overline(X) - overline(Y), U sqrt(frac(1, m, style: "horizontal") + frac(1, n, style: "horizontal")))
  $
  は自由度$m + n - 2$の$t$分布に従い、とくに有意水準を$alpha$とすれば
  / 両側検定: $T in {t mid(|) abs(t) > t_(m + n - 2) (alpha/2)} ==> mu_1 != mu_2$
  / 右側検定: $T in {t mid(|) t > t_(m + n - 2) (alpha)} ==> mu_1 > mu_2$
  / 左側検定: $T in {t mid(|) t < -t_(m + n - 2) (alpha)} ==> mu_1 < mu_2$
  がいえる。

+ より一般の場合、ウェルチの近似法により統計量
  $
    T_0 = frac(overline(X) - overline(Y), sqrt(frac(U_1^2, m, style: "horizontal") + frac(U_2^2, n, style: "horizontal")))
  $
  は、近似的に自由度が
  $
    c = frac((frac(U_1^2, m, style: "horizontal") + frac(U_2^2, n, style: "horizontal"))^2, frac((frac(U_1^2, m, style: "horizontal"))^2, m - 1) + frac((frac(U_2^2, n, style: "horizontal"))^2, n - 1))
  $
  に最も近い自然数$k$の$t$分布$t(k)$に従い、とくに有意水準を$alpha$とすれば
  / 両側検定: $T_0 in {t_0 mid(|) abs(t_0) > t_(k) (alpha/2)} ==> mu_1 != mu_2$
  / 右側検定: $T_0 in {t_0 mid(|) t_0 > t_(k) (alpha)} ==> mu_1 > mu_2$
  / 左側検定: $T_0 in {t_0 mid(|) t_0 < -t_(k) (alpha)} ==> mu_1 < mu_2$
  がいえる。

== $F$検定

=== 等分散の検定

平均$mu_1$、$mu_2$、分散$sigma_1^2$、$sigma_2^2$がともに未知である正規分布$N(mu_1, sigma_1^2)$および$N(mu_2, sigma_2^2)$の母分散$sigma_1^2$と$sigma_2^2$の検定を考える。

いま、「$sigma_1^2 = sigma_2^2$」を仮定すると、サイズが$m$、$n$である各標本の不偏分散$U_1^2$と$U_2^2$について$F$統計量
$ F = frac(frac(U_1^2, sigma_1^2, style: "horizontal"), frac(U_2^2, sigma_2^2, style: "horizontal")) = U_1^2/U_2^2 $
は自由度$(m - 1, n - 1)$の$F$分布に従い、とくに有意水準を$alpha$とすれば
/ 両側検定: $F in {f mid(|) f < F^(m - 1)_(n - 1) (1 - alpha/2) = frac(1, F^(n - 1)_(m - 1) (alpha/2)), f > F^(m - 1)_(n - 1) (alpha/2)} ==> sigma_1^2 != sigma_2^2$
/ 右側検定: $F in {f mid(|) f > F^(m - 1)_(n - 1) (alpha)} ==> sigma_1^2 > sigma_2^2$
/ 左側検定: $F in {f mid(|) f < F^(m - 1)_(n - 1) (1 - alpha) = frac(1, F^(n - 1)_(m - 1) (alpha))} ==> sigma_1^2 < sigma_2^2$
がいえる。
