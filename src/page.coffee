CiteTable = require './cite-table'
http = require 'http'
global.jQuery = require "jquery"
require 'bootstrap'
Citation = require './citation'

remote = require('electron').remote
ipc = require('electron').ipcRenderer
clipboard = require('electron').clipboard

searchButton = document.getElementById "searchButton"
authorField = document.getElementById "author"
titleField = document.getElementById "title"
citeTable = document.getElementById "citeTable"
# dialog = document.getElementById "dialog"
dialogContent = document.getElementById "dialogContent"

ct = new CiteTable(citeTable)


ipc.on "copy", ->
  cites = ct.getHighlighted()
  text = ""
  for cite in cites
    text += cite.toString()
    text += "\n"
  clipboard.writeText(text)

ipc.on "selectAll", ->
  ct.selectAll()

authorField.addEventListener "keyup", (event) ->
  if event.keyCode is 13
    searchButton.click()

titleField.addEventListener "keyup", (event) ->
  if event.keyCode is 13
    searchButton.click()

searchButton.addEventListener "click", =>
  jQuery(searchButton).button("loading")
  url = "http://www.ams.org/mathscinet/search/publications.html?pg4=AUCN&s4=#{authorField.value}&pg5=TI&s5=#{titleField.value}&fmt=bibtex&extend=1"
  http.get url, (res)=>
    jQuery(searchButton).button("reset")
    msg = ""
    if res.statusMessage is "Authorization Required"
      dialogContent.innerHTML = "<h5>You are not authorised to access MathSciNet.</h5>"
      jQuery("#modal").modal("show")
      return
    res.on "data", (data) =>
      msg += data
    res.on "end", =>
      bits = msg.split "<pre>"
      for bit in bits
        if bit.indexOf "</pre>" isnt -1
          bit = bit.substring 0, bit.indexOf("</pre>")
        continue if bit.indexOf("@") is -1
        bit = bit.substring(bit.indexOf("@")+1, bit.length)
        ct.add(new Citation(bit))
      ct.redraw()
