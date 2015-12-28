app = require('electron').app
ipc = require('electron').ipcMain
BrowserWindow = require('electron').BrowserWindow
Config = require './configuration'
require('electron').crashReporter.start([{
  productName: app.getName(),
  companyName: "Focus.apps",
  submitURL: "https://github.com/focus/bibteximport/issues",
  autoSubmit: true
  }])


newWindow= ->
  win = new BrowserWindow {width:800 , height:820}
  win.loadURL "file://#{__dirname}/index.html"

app.on "ready", ->
  require('./build-menu').buildMenu(newWindow)
  newWindow()

app.on "window-all-closed", ->
  if process.platform isnt "darwin"
    app.quit()

ipc.on "pair", ->
  win = new BrowserWindow {width: 1000, height: 800, show:false}
  win.loadURL "http://www.ams.org/pairing/pair_my_device.html"
  win.webContents.on "dom-ready", (event)->
    event.sender.executeJavaScript "doPairing = true; forcePairing = true; amsPairingLoad();"
    ses = event.sender.session
    ses.cookies.get {name: "amspairing"}, (error, cookies) ->
      if not error?
        Config.setConf "amspairing", cookies[0].value
        BrowserWindow.getFocusedWindow().send "paired"
      BrowserWindow.fromWebContents(event.sender).close()
