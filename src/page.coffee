LocalTable = require './local-table'
lt = new LocalTable(document.getElementById("localTable"))
http = require 'http'
global.jQuery = require "jquery"
require 'bootstrap'



fileName = document.getElementById "fileName"

ipc = require 'ipc'
path = require 'path'


ipc.on "open-file", (file) =>
  return unless file?
  if lt.readFromFile(file[0])
    ipc.send "set-title", path.basename(file[0])
    @file = file[0]

ipc.on "save-file", (file)=>
  if file?
    lt.saveToFile(file)
  else if @file?
    lt.saveToFile(@file)
    ipc.send "edited", false
  else
    ipc.send "saveAs"

searchButton = document.getElementById "searchButton"
authorField = document.getElementById "author"
titleField = document.getElementById "title"
modalTable = document.getElementById "modalTable"
modalAdd = document.getElementById "modalAdd"


searchButton.addEventListener "click", ->
  url = "http://www.ams.org/mathscinet/search/publications.html?pg4=AUCN&s4=#{authorField.value}&pg5=TI&s5=#{titleField.value}&fmt=bibtex&extend=1"
  http.get url, (res)->
    lt2 = new LocalTable(modalTable)
    jQuery("#modal").modal("show")
    if res.statusMessage is "Authorization Required"
      ipc.send "error", "You are not authorised to access MathSciNet"
