'use strict';

/* ---------------------------
  common
----------------------------- */
var remote = require('remote');
var fs     = remote.require('fs');
var util   = remote.require("util");
var exec   = remote.require('child_process').exec;

var ECT    = remote.require('ect');
var $      = require("./lib/js/jquery-2.1.4.min.js");


/* ---------------------------
  nginx
----------------------------- */
var nginx = nginx || {}

nginx.start = function(){
  exec('cp ./template/* ./cache/', function(err, stdout, stderr){
    if (err) { throw err; }
    logger.debug("Copy")
  })

  var renderer = ECT({ root : __dirname + '/template' });
  var data = { pwd: 'Hello, World!' };
  var out = renderer.render('nginx.conf.ect', data);
  fs.writeFile('./cache/nginx.conf', out , function (err) {
    if (err) { throw err; }
    logger.debug('Save');
  });

  exec('nginx -p `pwd` -c ./cache/nginx.conf', function(err, stdout, stderr){
    if (err) { throw err; }
    console.log('server started!');
  });

  logger.debug("nginx_start");
};


nginx.stop = function(){
  exec('nginx -s stop', function(err, stdout, stderr){
    if (err) { throw err; }
    logger.debug('server stoped!');
  });
};

/* ---------------------------
  logger
----------------------------- */
var logger = logger || {};
logger.puts = function(log){

  console.log(log);
  $("#console").text( $("#console").text()+"\n"+log );

  var psconsole = $('#console');
  psconsole.scrollTop(
      psconsole[0].scrollHeight - psconsole.height()
  );
}
logger.debug = function(){
  // 可変長引数を処理
  var args = [];
  for (var _i = 0; _i < arguments.length; _i++) {
    args.push(arguments[_i])
  }

  var dt = new Date();

  var log = util.format("[%s] [%s] [%s] %s", dt.toString(), "debug", "nginx", args);
  logger.puts(log)
}
logger.info = function(){

}
logger.warn = function(){

}
logger.error = function(){

}
logger.fatal = function(){

}



$("#nginx_start").on("click", function(){
  nginx.start();
});
$("#nginx_stop").on("click", function(){
  nginx.stop();
});