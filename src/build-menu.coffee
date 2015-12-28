Menu = require('electron').Menu
app = require('electron').app
ipc = require('electron').ipcMain
# dialog = require('electron').dialog



exports.buildMenu = (newWindowFunc)->
  name = app.getName()
  template = [
    {label: name
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
      {label: 'Minimize', accelerator: 'CmdOrCtrl+M', role: 'performMiniaturize'}
      {label: 'Close', accelerator: 'CmdOrCtrl+W', role: 'performClose'}
      {type: 'separator'}
      {label: 'Bring All to Front', role: 'arrangeInFront'}
    ]}
    {label: 'Help', submenu: [
      {label: 'Learn More', click: -> require('electron').shell.openExternal "http://www.batisengul.co.uk/"}
      ]}
  ]

  menu = Menu.buildFromTemplate(template)
  Menu.setApplicationMenu(menu)
