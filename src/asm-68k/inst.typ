#import "/lib/utils.typ": *

#let document-config = (
  title: "m68k Instructions",
  description: "About m68k instructions and their usage.",
  author: "Salty Lemon",
)

= Data

#link(
  "https://moodle.s.kyushu-u.ac.jp/pluginfile.php/2606430/mod_resource/content/1/講義1.pdf#page=27",
  "Reference",
)

```m68k
.dc.l  <value> [<value> ..]
.ds.l  <size>
.equ   <symbol> <value>
```

= Section

#link(
  "https://moodle.s.kyushu-u.ac.jp/pluginfile.php/2606430/mod_resource/content/1/講義1.pdf#page=28",
  "Reference",
)

```m68k
.text  [code]
.data  [.dc]
.bss   [.ds]
.end
```

= Jamp

```
bra.w  <label>
jmp    <addr>
```

= Branch

#link(
  "https://moodle.s.kyushu-u.ac.jp/pluginfile.php/2606432/mod_resource/content/1/講義2.pdf#page=4",
  "Reference about branch",
),
#link(
  "https://moodle.s.kyushu-u.ac.jp/pluginfile.php/2606430/mod_resource/content/1/講義1.pdf#page=13",
  "Reference about CCR",
)

```m68k
cmp.l  <x> <y>  // CCR := y - x

bhi    <label>  // on CCR > 0 (x < y)
bcc    <label>  // on CCR >= 0 (x <= y)
beq    <label>  // on CCR == 0 (x == y)
bne    <label>  // on CCR != 0 (x != y)
```

= Sub routine

```m68k
bsr.w  <label>
jsr    <addr>
rts             // return
```
