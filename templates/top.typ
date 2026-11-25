#import "/lib/styles.typ": nav, style, styled
#import "/lib/appendix.typ": roots

#set document(title: "mdocs")

#show: style.with(doc-type: "website")

#title()

#list(..roots.map(n => link("./" + n, n)))

#divider()

#html.small[Report any errors/issues on #{ link("https://github.com/okik-en/mathematical-documents/issues", "our repository") }.
  #{ html.span(id: "last_updated", "") }]

#html.script(
  "(async () => document.getElementById('last_updated').textContent = await fetch('https://api.github.com/repos/okik-en/mathematical-documents/deployments').then(x => x.json()).then(x => `This site was last updated at ${new Date(Date.parse(x[0].updated_at)).toLocaleString()}.`))();",
)
