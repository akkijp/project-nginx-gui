'use strict';
// http://qiita.com/Quramy/items/a4be32769366cfe55778

const electron      = require('electron');
const app           = electron.app;
const BrowserWindow = electron.BrowserWindow;
const path          = require('path');

require('crash-reporter').start();

var root = global.root = path.join( __dirname, "/" );

// Quit when all windows are closed and no other one is listening to this.
app.on('window-all-closed', function() {
  if (app.listeners('window-all-closed').length == 1)
    app.quit();
});

app.on('ready', function() {
  var mainWindow = null;

  // ブラウザ(Chromium)の起動, 初期画面のロード
  mainWindow = new BrowserWindow({
    width: 40*14,
    height: 30*14,
    show: false,
    // resizable: false
  });

  var filePath = path.join( root, 'main.html' );
  mainWindow.loadUrl('file://' + filePath);

  console.log( filePath);

  mainWindow.on('closed', function() {
    mainWindow = null;
    process.exit(0);
  });

  mainWindow.show();
});
