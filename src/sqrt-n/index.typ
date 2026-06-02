#import "../../templates/template.typ": *
#import "../../templates/html.typ": *
#import "../../templates/consts.typ": *
#show: template

#set document(title: "平方根表", author: okik-en-data.authors.salty-lemon)

#show: html-init

#let cs(..args) = math.cases(
  gap: 8pt,
  ..args.pos().map(child => math.display(child)),
)

#title()
#author()

= 主要な自然数の平方根

#figure(
  caption: "平方根表",
  table(
    stroke: none,
    align: (x, y) => if (x == 3) { left } else { center },
    columns: 4,
    $sqrt(2)$, $approx$, $bold(1.41421356)24$, [(一夜一夜に人見頃)],
    $sqrt(3)$, $approx$, $bold(1.7320508)076$, [(人並に奢れや)],
    $sqrt(5)$, $approx$, $bold(2.2360679)775$, [(富士山麓鸚鵡鳴く)],
    $sqrt(6)$, $approx$, $bold(2.44948974)28$, [(煮よ良くよ焼くなよ)],
    $sqrt(7)$, $approx$, $bold(2.64575)13111$, [(菜に虫居ない)],
    $sqrt(10)$, $approx$, $bold(3.16227766)02$, [(三色に並ぶ)],
    $sqrt(11)$, $approx$, $bold(3.31662479)04$, [(佐々一人轆轤首し泣く)],
    $sqrt(13)$, $approx$, $bold(3.6055512)755$, [(寒がれば請う551に)],
  ),
)
