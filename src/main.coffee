app = require('electron').app
ipc = require('electron').ipcMain
dialog = require('electron').dialog
BrowserWindow = require('electron').BrowserWindow
Config = require './configuration'

require('electron').crashReporter.start({
  productName: app.getName(),
  companyName: "Focus.apps",
  submitURL: "https://github.com/focus/bibteximport/issues",
  autoSubmit: true
  })

compareVersions= (ver1, ver2)->
  vp1 = ver1.split "."
  vp2 = ver2.split "."
  for v, i in vp1
    if i > vp2.length-1 or v > vp2[i]
      return true
  return false


checkForUpdates= ->
  request = require 'request'
  lastDate = Config.getConf "updateCheckDate"
  if lastDate?
    return if (Date.now() - lastDate)/86400000 < 5
  request {url:"https://github.com/Focus/BibtexImport/releases/latest", followRedirect: false}, (error, response, body)->
    if error
      console.log(error)
      return
    if response.statusCode isnt 302
      console.log(response)
      return
    version = body.match(/\/v(.*?)"/)
    if version.length > 1
      pjson = require '../package.json'
      Config.setConf "updateCheckDate", Date.now()
      if compareVersions version[1], pjson.version
        dialog.showMessageBox {
          type: "info"
          title: "Update available"
          message: "A new update is available to download! You have version #{pjson.version} and the latest version is #{version[1]}. Would you like to visit our website to obtain the new version?"
          buttons: ["No", "Yes"]
        } , (res)->
          if res
            require('electron').shell.openExternal pjson.homepage



newWindow= ->
  win = new BrowserWindow {width:800 , height:820}
  win.loadURL "file://#{__dirname}/index.html"
  if not Config.getConf("firstTime")?
    win.webContents.on "dom-ready", ->
      win.send "agreement"
      Config.setConf "firstTime", "done"

app.on "ready", ->
  require('./build-menu').buildMenu(newWindow)
  newWindow()
  checkForUpdates()

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
