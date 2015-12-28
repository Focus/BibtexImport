app = require('electron').app
ipc = require('electron').ipcMain
BrowserWindow = require('electron').BrowserWindow
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
