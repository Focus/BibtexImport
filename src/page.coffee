CiteTable = require './cite-table'
request = require 'request'
global.jQuery = require "jquery"
require 'bootstrap'
Citation = require './citation'
Config = require './configuration'

remote = require('electron').remote
ipc = require('electron').ipcRenderer
clipboard = require('electron').clipboard

searchButton = document.getElementById "searchButton"
authorField = document.getElementById "author"
titleField = document.getElementById "title"
citeTable = document.getElementById "citeTable"
# dialog = document.getElementById "dialog"
dialogContent = document.getElementById "dialogContent"
dialogTitle = document.getElementById "modalTitle"

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

ipc.on "agreement", ->
  modalTitle.innerHTML = "Licence agreement"
  dialogContent.innerHTML = "By using this app, you agree to the posted terms and conditions of use of AMS electronic products, and you confirm that you are an authorized user as per the terms and conditions of the signed license agreement(s) of the subscribing institution. Note that any violation of the posted terms and conditions and/or the terms and conditions of the signed license agreement(s) will result in termination of your access."
  jQuery("#modal").modal("show")

ipc.on "paired", ->
  modalTitle.innerHTML = "Remote access obtained!"
  dialogContent.innerHTML = "I have obtained remote access for you. This means that you will have access to MathSciNet everywhere."
  jQuery("#modal").modal("show")

authorField.addEventListener "keyup", (event) ->
  if event.keyCode is 13
    searchButton.click()

titleField.addEventListener "keyup", (event) ->
  if event.keyCode is 13
    searchButton.click()

searchButton.addEventListener "click", =>
  jQuery(searchButton).button("loading")
  url = "http://www.ams.org/mathscinet/search/publications.html?pg4=AUCN&s4=#{authorField.value}&pg5=TI&s5=#{titleField.value}&fmt=bibtex&extend=1"
  cookie = request.cookie("amspairing=" + Config.getConf("amspairing"))
  jar = request.jar()
  jar.setCookie cookie, url
  request {url: url, jar: jar}, (error, response, body)=>
    jQuery(searchButton).button("reset")
    if error
      console.log(error)
      return
    if response.statusCode is 401
      modalTitle.innerHTML = "You are not authorised to access MathSciNet."
      dialogContent.innerHTML = "You do not have the authorisation to access MathSciNet. You also do not have remote access. If you are able to get to an institution with a subsciption I will automatically get remote access so that you are able to use this elsewhere as well."
      jQuery("#modal").modal("show")
      return
    if not Config.getConf("amspairing")?
      ipc.send "pair"
    bits = body.split "<pre>"
    ct.flush()
    for bit in bits
      if bit.indexOf "</pre>" isnt -1
        bit = bit.substring 0, bit.indexOf("</pre>")
      continue if bit.indexOf("@") is -1
      bit = bit.substring(bit.indexOf("@")+1, bit.length)
      ct.add(new Citation(bit))
    ct.redraw()
