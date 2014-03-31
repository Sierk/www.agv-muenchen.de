#= require jquery.min
#= require bootstrap

#= require hyphenator/Hyphenator
#= require hyphenator/patterns/de

#= require lunr/string.trunc
#= require lunr/lunr.min
#= require lunr/mustache
#= require lunr/uri
#= require lunr/jquery.lunr.search

#= require_tree .

$("a[rel=tooltip]").tooltip()

Hyphenator.config useCSS3hyphenation: true
Hyphenator.run()
