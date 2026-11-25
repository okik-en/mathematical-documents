#let appendix = yaml("/appendix.yaml")

#let _name(node) = if type(node) == str { node } else { node.keys().first() }

#let _walk(nodes, parent) = (
  nodes
    .map(node => {
      let path = if parent == none { _name(node) } else { parent + "/" + _name(node) }
      if type(node) == str {
        ((kind: "file", path: path),)
      } else {
        ((kind: "folder", path: path),) + _walk(node.values().first(), path)
      }
    })
    .flatten()
)

#let pages = _walk(appendix, none)

#let folders = pages.filter(p => p.kind == "folder").map(p => p.path)
#let files = pages.filter(p => p.kind == "file").map(p => p.path)

#let roots = appendix.map(_name)

#let children(path) = (
  path
    .split("/")
    .fold(appendix, (nodes, key) => (
      nodes.find(n => type(n) == dictionary and _name(n) == key).values().first()
    ))
    .map(_name)
)
