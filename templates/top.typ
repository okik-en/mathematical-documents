#import "/lib/styles.typ": style, styled
#set document(title: "目次")

#show: style.with(doc-type: "website")

#title()

#let appendix = yaml("/appendix.yaml")

#list(..appendix.map(e => link("./" + e.keys().first(), e.keys().first())))

#divider()

#html.small[Report any errors/issues on #{ link("https://github.com/okik-en/mathematical-documents/issues", "our repository") }.
  #{ html.span(id: "last_updated", "") }]

#html.script(
  "(async () => document.getElementById('last_updated').textContent = await fetch('https://api.github.com/repos/okik-en/mathematical-documents/deployments').then(x => x.json()).then(x => `This site was last updated at ${new Date(Date.parse(x[0].updated_at)).toLocaleString()}.`))();",
)
