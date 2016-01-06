Menu = require('electron').Menu
app = require('electron').app
ipc = require('electron').ipcMain
pjson = require '../package.json'
# dialog = require('electron').dialog



exports.buildMenu = (newWindowFunc)->
  name = app.getName()
  template = [
    {label:'File'
    submenu: [
        {label:'New', accelerator: 'CmdOrCtrl+N', click: ->
          newWindowFunc() }
    ]}
    {label: 'Edit'
    submenu: [
      {label: 'Undo', accelerator: 'CmdOrCtrl+Z', role: 'undo'}
      {label: 'Redo', accelerator: 'Shift+CmdOrCtrl+Z', role: 'redo'}
      {type: 'separator'}
      {label: 'Cut', accelerator: 'CmdOrCtrl+X', role: 'cut'}
      {label: 'Copy', accelerator: 'CmdOrCtrl+C', click: (item, focusedWindow)->
        focusedWindow.send "copy" }
      {label: 'Paste', accelerator: 'CmdOrCtrl+V', role: 'paste'}
      {label: 'Select All', accelerator: 'CmdOrCtrl+A', click: (item, focusedWindow)->
        focusedWindow.send "selectAll" }
    ]}
    {label: 'View'
    submenu: [
      {label: 'Reload',accelerator: 'CmdOrCtrl+R', click: (item, focusedWindow)->
        focusedWindow.reload() if focusedWindow?}
      {label: 'Toggle DevTools',accelerator: 'Alt+CmdOrCtrl+I', click: (item, focusedWindow)->
        focusedWindow.toggleDevTools()}
    ]}
    {label: 'Window'
    submenu: [
      {label: 'Minimize', accelerator: 'CmdOrCtrl+M', role: 'minimize'}
      {label: 'Close', accelerator: 'CmdOrCtrl+W', role: 'close'}
    ]}
    {label: 'Help', submenu: [
      {label: 'Learn More', click: -> require('electron').shell.openExternal pjson.homepage}
      ]}
  ]
  if process.platform is "darwin"
    template.unshift {label: name
    submenu: [
      {label: 'About ' + name, role: 'about'}
      {type: 'separator'}
      {label: 'Services', role: "services", submenu: []}
      {type: 'separator'}
      {label: 'Hide ' + name, accelerator: 'CmdOrCtrl+H', role: 'hide'}
      {label: 'Hide Others', accelerator: 'CmdOrCtrl+Shift+H', role: 'hideothers'}
      {label: 'Show All', role: 'unhide'}
      {type: 'separator'}
      {label: 'Quit', accelerator: 'CmdOrCtrl+Q', click: ->
        app.quit() }
    ]}
    template[4].submenu.push({
      type: 'separator'
      },
      {
        label: 'Bring All to Front'
        role: 'front'
      })


  menu = Menu.buildFromTemplate(template)
  Menu.setApplicationMenu(menu)
