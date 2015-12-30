'use strict'
# http://qiita.com/Quramy/items/a4be32769366cfe55778
# http://qiita.com/Quramy/items/a4be32769366cfe55778
electron = require('electron')
app = electron.app
Menu = electron.Menu
BrowserWindow = electron.BrowserWindow
path = require('path')
exec = require('child_process').exec
Promise = require('promise')

###
# Create default menu.
# URL https://github.com/atom/electron/releases
#       => electron-v0.35.4-darwin-x64.zip
# from electron-v0.35.4-darwin-x64/Electron.app/Contents/Resources/default_app/main.js
###

app.once 'ready', ->
  if Menu.getApplicationMenu()
    return
  template = [
    {
      label: 'Edit'
      submenu: [
        {
          label: 'Undo'
          accelerator: 'CmdOrCtrl+Z'
          role: 'undo'
        }
        {
          label: 'Redo'
          accelerator: 'Shift+CmdOrCtrl+Z'
          role: 'redo'
        }
        { type: 'separator' }
        {
          label: 'Cut'
          accelerator: 'CmdOrCtrl+X'
          role: 'cut'
        }
        {
          label: 'Copy'
          accelerator: 'CmdOrCtrl+C'
          role: 'copy'
        }
        {
          label: 'Paste'
          accelerator: 'CmdOrCtrl+V'
          role: 'paste'
        }
        {
          label: 'Select All'
          accelerator: 'CmdOrCtrl+A'
          role: 'selectall'
        }
      ]
    }
    {
      label: 'View'
      submenu: [
        {
          label: 'Reload'
          accelerator: 'CmdOrCtrl+R'
          click: (item, focusedWindow) ->
            if focusedWindow
              focusedWindow.reload()
            return

        }
        {
          label: 'Toggle Full Screen'
          accelerator: do ->
            if process.platform == 'darwin'
              'Ctrl+Command+F'
            else
              'F11'
          click: (item, focusedWindow) ->
            if focusedWindow
              focusedWindow.setFullScreen !focusedWindow.isFullScreen()
            return

        }
        {
          label: 'Toggle Developer Tools'
          accelerator: do ->
            if process.platform == 'darwin'
              'Alt+Command+I'
            else
              'Ctrl+Shift+I'
          click: (item, focusedWindow) ->
            if focusedWindow
              focusedWindow.toggleDevTools()
            return

        }
      ]
    }
    {
      label: 'Window'
      role: 'window'
      submenu: [
        {
          label: 'Minimize'
          accelerator: 'CmdOrCtrl+M'
          role: 'minimize'
        }
        {
          label: 'Close'
          accelerator: 'CmdOrCtrl+W'
          role: 'close'
        }
      ]
    }
    {
      label: 'Help'
      role: 'help'
      submenu: [
        {
          label: 'Learn More'
          click: ->
            shell.openExternal 'http://electron.atom.io'
            return

        }
        {
          label: 'Documentation'
          click: ->
            process_versions_electron = process.versions.electron
            shell.openExternal 'https://github.com/atom/electron/tree/v' + process_versions_electron + '/docs#readme'
            return

        }
        {
          label: 'Community Discussions'
          click: ->
            shell.openExternal 'https://discuss.atom.io/c/electron'
            return

        }
        {
          label: 'Search Issues'
          click: ->
            shell.openExternal 'https://github.com/atom/electron/issues'
            return

        }
      ]
    }
  ]
  if process.platform == 'darwin'
    template.unshift
      label: 'Electron'
      submenu: [
        {
          label: 'About Electron'
          role: 'about'
        }
        { type: 'separator' }
        {
          label: 'Services'
          role: 'services'
          submenu: []
        }
        { type: 'separator' }
        {
          label: 'Hide Electron'
          accelerator: 'Command+H'
          role: 'hide'
        }
        {
          label: 'Hide Others'
          accelerator: 'Command+Shift+H'
          role: 'hideothers'
        }
        {
          label: 'Show All'
          role: 'unhide'
        }
        { type: 'separator' }
        {
          label: 'Quit'
          accelerator: 'Command+Q'
          click: ->
            app.quit()
            return

        }
      ]
    template[3].submenu.push { type: 'separator' },
      label: 'Bring All to Front'
      role: 'front'
  menu = Menu.buildFromTemplate(template)
  Menu.setApplicationMenu menu
  return
require('crash-reporter').start()
root = global.root = path.join(__dirname, '/')

server_stop = (callback) ->
  promise1 = new Promise((resolve, reject) ->
    exec '/usr/local/bin/nginx -s stop', (err, stdout, stderr) ->
      if err
        reject err
      else
        resolve()
      return
    return
)
  promise2 = new Promise((resolve, reject) ->
    exec '/usr/local/sbin/php56-fpm stop', (err, stdout, stderr) ->
      if err
        reject err
      else
        resolve()
      return
    return
)
  promise3 = new Promise((resolve, reject) ->
    exec '/usr/local/bin/mysql.server stop', (err, stdout, stderr) ->
      if err
        reject err
      else
        resolve()
      return
    return
)
  Promise.all([
    promise1
    promise2
    promise3
  ]).nodeify callback

# Quit when all windows are closed and no other one is listening to this.
app.on 'window-all-closed', ->
  if app.listeners('window-all-closed').length == 1
    app.quit()
  return
app.on 'ready', ->
  mainWindow = null
  # ブラウザ(Chromium)の起動, 初期画面のロード
  mainWindow = new BrowserWindow(
    width: 40 * 14
    height: 30 * 15
    show: false)
  filePath = path.join(root, 'main.html')
  mainWindow.loadUrl 'file://' + filePath
  console.log filePath
  mainWindow.on 'closed', ->
    mainWindow = null
    server_stop ->
      process.exit 0
      return
    return
  mainWindow.show()
  return
