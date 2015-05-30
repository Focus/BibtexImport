app = require 'app'
BrowserWindow = require 'browser-window'
ipc = require 'ipc'
dialog = require 'dialog'
Menu = require 'menu'
MenuTemplate = require './menu-template'

require('crash-reporter').start()

mainWindow = null
title = "Untitled.bib"
edited = false


app.on "window-all-closed", ->
  if process.platform isnt "darwin"
    app.quit()

checkSave= ->
  action = dialog.showMessageBox mainWindow, {
    type: "warning"
    title: "#{title} has been edited"
    message: "#{title} has unsaved changes. Would you like to save?"
    buttons: ["Save", "Don't Save", "Cancel"]
    }
  return true if action is 2
  return false if action is 1

  mainWindow.send "save-file"

app.on "before-quit", (event)->
  if edited and checkSave()
    event.preventDefault()


app.on "ready", ->
  mainWindow = new BrowserWindow width:1200 , height:1000
  mainWindow.loadUrl "file://#{__dirname}/index.html"
  mainWindow.setTitle title
  mainWindow.on "closed", ->
    mainWindow = null

  menu = Menu.buildFromTemplate(MenuTemplate.getTemplate(app,mainWindow))
  Menu.setApplicationMenu(menu)

  ipc.on "quit", ->
    app.quit()
  ipc.on "open", ->
    mainWindow.send "open-file", dialog.showOpenDialog()
  ipc.on "save", ->
    mainWindow.send "save-file"
  ipc.on "saveAs", ->
    mainWindow.send "save-file", dialog.showSaveDialog()
  ipc.on "set-title", (event, arg) ->
    title = arg
    edited = false
    mainWindow.setTitle arg
  ipc.on "edited", (event, arg)->
    return if edited && arg
    if arg
      edited = true
      title += "*"
      mainWindow.setTitle title
    else
      edited = false
      if title[title.length-1] is '*'
        title = title.substring 0, title.length-1
        mainWindow.setTitle title
  ipc.on "error", (event, arg)->
    dialog.showMessageBox mainWindow, {
      type: "warning"
      title: "Error"
      message: arg
      buttons: ["Ok"]
      }
