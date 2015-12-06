'use strict';
// http://qiita.com/Quramy/items/a4be32769366cfe55778

var app = require('app');
var path = require('path');
const BrowserWindow = require('electron').BrowserWindow;

require('crash-reporter').start();

var root = global.root = path.join( __dirname, "/" );

app.on('window-all-closed', function() {
  if (process.platform != 'darwin')
    app.quit();
});

app.on('ready', function() {
  var mainWindow = null;

  // ブラウザ(Chromium)の起動, 初期画面のロード
  mainWindow = new BrowserWindow({
    width: 40*13,
    height: 30*13,
    show: false,
    // resizable: false
  });

  var filePath = path.join( root, 'main.html' );
  mainWindow.loadUrl('file://' + filePath);

  console.log( filePath);

  mainWindow.on('closed', function() {
    mainWindow = null;
  });

  mainWindow.show();
});