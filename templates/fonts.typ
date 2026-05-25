#let emoji-regex = regex("[\u{2600}-\u{27BF}\u{1F000}-\u{1FFFF}]")

#let fonts = (
  serif: "New Computer Modern",
  serif-cjk: "Yu Mincho",
  sans: "Arial",
  sans-cjk: "Yu Gothic",
  mono: "Fira Code",
  mono-cjk: "Yu Gothic UI",
  math: "New Computer Modern Math",
  emoji: "Noto Emoji",
)

#let family = (
  serif: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
  sans: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.sans, covers: "latin-in-cjk"), fonts.sans-cjk),
  mono: ((name: fonts.emoji, covers: emoji-regex), (name: fonts.mono, covers: "latin-in-cjk"), fonts.mono-cjk),
  math: (fonts.math, (name: fonts.serif, covers: "latin-in-cjk"), fonts.serif-cjk),
)
