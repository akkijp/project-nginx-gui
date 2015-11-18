'use strict';
var remote = require('remote');
var fs = remote.require('fs');
var exec = remote.require('child_process').exec;

var ECT = remote.require('ect');
var $ = require("./lib/js/jquery-2.1.4.min.js");

var nginx = nginx || {}


nginx.start = function(){
  exec('cp ./template/* ./cache/', function(err, stdout, stderr){
    console.log("Copy")
  })

  var renderer = ECT({ root : __dirname + '/template' });
  var data = { pwd: 'Hello, World!' };
  var out = renderer.render('nginx.conf.ect', data);
  fs.writeFile('./cache/nginx.conf', out , function (err) {
    if (err) { throw err; }
    console.log ('Save');
  });

  exec('nginx -p `pwd` -c ./cache/nginx.conf', function(err, stdout, stderr){
    console.log('server started!');
  });

  console.log("nginx_start");
};


nginx.stop = function(){
  exec('nginx -s stop', function(err, stdout, stderr){
    console.log('server stoped!');
  });
};


$("#nginx_start").on("click", function(){
  nginx.start();
});
$("#nginx_stop").on("click", function(){
  nginx.stop();
});