#import "/lib/utils.typ": *

#let document-config = (
  title: "m68k Registers",
  description: "About m68k registers and their sizes.",
  author: "Salty Lemon",
)

= Kind of Registers

/ Data Register: `%d0` -- `%d7`
/ Address Register: `%a0` -- `%a6`
/ Stack Pointer: `%a7`
/ Program Counter: `%pc`
/ Status Register: `sr`
  #link(
    "https://moodle.s.kyushu-u.ac.jp/pluginfile.php/2606430/mod_resource/content/1/講義1.pdf#page=13",
    text(size: 6pt, emoji.chain),
  )

= Size of Registers

/ Byte `.b`: 1 Byte = 8 bits
/ Word `.w`: 2 Bytes = 16 bits
/ Long Word `.l`: 4 Bytes = 32 bits (register size)

= Data Representation

Little Endian

```
0x12345678
---
00: 1 2
02: 3 4
04: 5 6
06: 7 8
```

= Addressing Modes

/ Immediate data: `#0x1234` #sym.arrow `0x1234`
/ Absolute address: `0x1000` #sym.arrow `(mem+) 0x1000`
/ Data/Address register direct: `%a0` #sym.arrow `(reg+) a0`
/ Address register indirect: `(%a0)` #sym.arrow `(mem+) reg[a0]`
/ Postincrement address register indirect: `(%a0)+` #sym.arrow `(mem+) reg[a0]++`
/ Predecrement address register indirect: `-(%a0)` #sym.arrow `(mem+) --reg[a0]`
/ Indexed address register indirect: `d8(%a0, %d1.l)` #sym.arrow `(mem+) reg[a0] + reg[d1] + FFFFFFFF`
