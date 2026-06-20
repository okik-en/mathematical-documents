#import "../../templates/template.typ": *
#import "../../templates/html.typ": *
#import "../../templates/consts.typ": *
#show: template

#set document(
  title: "積分に関するTIPS",
  description: "積分に関して知っておいた方がよい知識をまとめたページ。",
  author: okik-en-data.authors.salty-lemon,
)

#show: html-init

#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)

#title()
#author()

#outline()

= ワイエルシュトラス置換

三角関数の積分
$
  I(theta) = integral f(sin theta, cos theta, tan theta) dif theta
$
を、ワイエルシュトラス置換
$
  t = tan theta/2
$
により解くことを考える。

置換の両辺を微分することにより
$
  dif t = 1/2 frac(dif theta, cos^2 theta/2) ==> frac(2, 1 + t^2) dif t = dif theta
$
を得ることができる。また
$
  cs(
    sin theta = 2 sin theta/2 cos theta/2 = 2 tan theta/2 cos^2 theta/2 = frac(2 tan theta, 1 - tan^2 theta/2) = frac(2 t, 1 - t^2),
    cos theta = 2 cos^2 theta/2 - 1 = frac(2, 1 - tan^2 theta/2) - 1 = frac(1 + tan^2 theta/2, 1 - tan^2 theta/2) = frac(1 + t^2, 1 - t^2),
    tan theta = frac(sin theta, cos theta) = frac(2 t, 1 + t^2)
  )
$
であるから
$
  I(theta) = 2 integral f(frac(2 t, 1 - t^2), frac(1 + t^2, 1 - t^2), frac(2 t, 1 + t^2)) frac(dif t, 1 + t^2)
$
という有理関数の積分に帰着できる。

= 部分分数分解による積分

以下の部分分数分解を考える：
$
  frac(1, (1 - t^2)^2) = 1/4 [frac(1, 1 + t) + frac(1, 1 - t) + frac(1, (1 + t)^2) + frac(1, (1 - t)^2)]
$

これにより
$
  integral frac(dif theta, sin^3 theta) &= integral frac(sin theta, sin^4 theta) dif theta = integral frac(- (cos theta)', (1 - cos^2 theta)^2) dif theta = - integral frac(dif t, (1 - t^2)^2) \
  & = - 1/4 [integral frac(dif t, 1 + t) + integral frac(dif t, 1 - t) + integral frac(dif t, (1 + t)^2) + integral frac(dif t, (1 - t)^2)] \
  & = - 1/4 [log abs(1 + t) - log abs(1 - t) - frac(1, 1 + t) + frac(1, 1 - t)] + C \
  & = 1/4 log abs(frac(1 - t, 1 + t)) - 1/2 frac(t, 1 - t^2) + C \
  & = 1/4 log (frac(1 - cos theta, 1 + cos theta)) - 1/2 frac(tan theta, sin theta) + C
$
が得られる。
また同様にして
$
  integral frac(dif theta, cos^3 theta) &= integral frac(cos theta, cos^4 theta) dif theta = integral frac((sin theta)', (1 - sin^2 theta)^2) = integral frac(dif t, (1 - t^2)^2) \
  & = 1/4 [integral frac(dif t, 1 + t) + integral frac(dif t, 1 - t) + integral frac(dif t, (1 + t)^2) + integral frac(dif t, (1 - t)^2)] \
  & = 1/4 [log abs(1 + t) - log abs(1 - t) - frac(1, 1 + t) + frac(1, 1 - t)] + C \
  & = 1/4 log abs(frac(1 + t, 1 - t)) + 1/2 frac(t, 1 - t^2) + C \
  & = 1/4 log (frac(1 + sin theta, 1 - sin theta)) + 1/2 frac(tan theta, cos theta) + C
$
も得られる。
