#import "/lib/styles.typ": nav, style, styled

#let __path__ = sys.inputs.at("path")
#set document(title: __path__)

#show: style.with(doc-type: "website")

#nav(__path__)

#title()

#let appendix = yaml("/appendix.yaml")

#list(
  ..(appendix, ..__path__.split("/"))
    .reduce((acc, key) => acc.find(x => x.keys().first() == key).values().first())
    .map(n => link("./" + n, n)),
)
