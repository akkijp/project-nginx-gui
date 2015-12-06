

/* ---------------------------
  common
----------------------------- */
var remote  = require('remote');
var util    = remote.require("util");
var path    = remote.require("path");
var process = remote.require("process");
var exec    = remote.require('child_process').exec;

var $       = require("./js/lib/jquery-2.1.4.min.js");
var ECT     = remote.require('ect');

// from https://github.com/jprichardson/node-fs-extra
var fs      = remote.require('fs-extra');


var saveSettings = function(){
  var port = $(':text[name="port"]').val();
  var root = $(':text[name="root"]').val();
  fs.writeFile("settings.json", JSON.stringify({
    "port": port,
    "root": root
  }));
};

var readSettings = function(){
  return JSON.parse(fs.readFileSync("settings.json", 'utf8'));
};
/* ---------------------------
  init
----------------------------- */
(function(){
  var json = readSettings()
  var port = $(':text[name="port"]').val(json.port);
  var root = $(':text[name="root"]').val(json.root);
})()

/* ---------------------------
  nginx
----------------------------- */
var nginx = nginx || {}

nginx.start = function(){

  var copySettings = function(){
    var d = new $.Deferred;
    fs.copy('./template/', './cache/', function (err) {
      if (err) return console.error(err)
      d.resolve();
    }); // copies directory, even if it has subdirectories or files
    return d.promise();
  }

  var writeCustomSettings = function(){
    var d = new $.Deferred;
    var renderer = ECT({ root : __dirname + '/template' });

    var port = $(':text[name="port"]').val();
    var root = $(':text[name="root"]').val();

    var data = {
      "port": port,
      "root": root
    };
    var out = renderer.render('nginx.conf.ect', data);
    fs.writeFile('./cache/nginx.conf', out , function (err) {
      if (err) { throw err; }
      d.resolve();
    });
    return d.promise();
  }

  var startNginx = function(){
    var d = new $.Deferred;
    exec('nginx -p `pwd` -c ./cache/nginx.conf', function(err, stdout, stderr){
      if (err) { throw err; }
      logger.debug('nginx start!');
      d.resolve();
    });
    return d.promise();
  }

  copySettings()
    .then(writeCustomSettings)
    .then(startNginx)
    .then(saveSettings)

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
  $("#console textarea").text( $("#console textarea").text()+"\n"+log );

  var psconsole = $("#console textarea");
  psconsole.scrollTop(
      psconsole[0].scrollHeight - psconsole.height()
  );
};
logger.debug = function(){
  // 可変長引数を処理
  var args = [];
  for (var _i = 0; _i < arguments.length; _i++) {
    args.push(arguments[_i])
  }

  var dt = new Date();

  var log = util.format("[%s] [%s] [%s] %s", dt.toString(), "debug", "nginx", args);
  logger.puts(log)
};
logger.info = function(){

};
logger.warn = function(){

};
logger.error = function(){

};
logger.fatal = function(){

};

/* ---------------------------
  bind
----------------------------- */
$("#nginx_start").on("click", function(){
  nginx.start();
});
$("#nginx_stop").on("click", function(){
  nginx.stop();
});
$("#settings").on("click", function(){

});
