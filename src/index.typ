#import "../templates/template.typ": *
#import "../templates/html.typ": html-init

#show: template
#show: html-init

#title("数学的読み物置き場")

#let src = yaml("../appendix.yaml")

#let walker(dir, path: "") = list(
  ..dir.map(child => {
    if type(child) == dictionary {
      let dir = path + "/" + child.keys().first()
      link(dir.replace(regex("^/[^/]*"), "."), dir)
      walker(child.values().first(), path: dir)
    } else if type(child) == str {
      let file = path + "/" + child
      link(file.replace(regex("^/[^/]*"), "."), file)
    }
  }),
)

#walker(src)
