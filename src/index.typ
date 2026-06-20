#import "../templates/template.typ": *
#import "../templates/html.typ": *

#show: template

#set document(title: "目次")

#show: html-init

#title()

#let src = yaml("../appendix.yaml")

#let walker(dir, path: "") = list(
  ..dir.map(child => {
    if type(child) == dictionary {
      let dir = path + "/" + child.keys().first()
      link(dir.replace(regex("^/[^/]*"), "."), raw(dir))
      walker(child.values().first(), path: dir)
    } else if type(child) == str {
      let file = path + "/" + child
      link(file.replace(regex("^/[^/]*"), "."), raw(file))
    }
  }),
)

#tree(walker(src))
