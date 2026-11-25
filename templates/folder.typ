#import "/lib/styles.typ": nav, style, styled
#import "/lib/appendix.typ": children

#let __path__ = sys.inputs.at("path")
#set document(title: __path__)

#show: style.with(doc-type: "website")

#nav(__path__)

#title()

#list(..children(__path__).map(n => link("./" + n, n)))
