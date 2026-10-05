#import "/lib/styles.typ": nav, style, styled

#let __path__ = sys.inputs.at("path")

#import "/src/" + __path__ + ".typ": document-config

#set document(..document-config)
#show: style

#nav(__path__)

#title()
#outline()

#include "/src/" + __path__ + ".typ"
