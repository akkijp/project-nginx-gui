

/* ---------------------------
  common
----------------------------- */
var remote  = require('remote'),
    util    = remote.require("util"),
    path    = remote.require("path"),
    process = remote.require("process"),
    exec    = remote.require('child_process').exec;

var $       = require("./js/lib/jquery-2.1.4.min.js");
var ECT     = remote.require('ect');

// from https://github.com/jprichardson/node-fs-extra
var fs      = remote.require('fs-extra');


var conf_path = path.join(process.env.HOME, '/.nginx-gui.conf.d/');

var nginx_conf_dir = path.join(conf_path, '/nginx.d/');
var app_conf_file   = path.join(conf_path, "settings.json");

var saveSettings = function(){
  var port = $(':text[name="port"]').val();
  var root = $(':text[name="root"]').val();
  fs.writeFile(app_conf_file, JSON.stringify({
    "port": port,
    "root": root
  }));
};

var readSettings = function(){
  return JSON.parse(fs.readFileSync(app_conf_file, 'utf8'));
};
/* ---------------------------
  init
----------------------------- */
(function(){
  $(':text[name="port"]').attr("placeholder", 8080);
  $(':text[name="root"]').attr("placeholder", process.env.HOME);

  // check file exists
  fs.access(app_conf_file, fs.R_OK | fs.W_OK, function(err){
    if(!err){
      var json = readSettings()
      $(':text[name="port"]').val(json.port);
      $(':text[name="root"]').val(json.root);
    }
  })
})()

/* ---------------------------
  nginx
----------------------------- */
var nginx = nginx || {}

nginx.start = function(){

  var copySettings = function(){
    var d = new $.Deferred;
    fs.copy('./template/', nginx_conf_dir, function (err) {
      if (err) return console.error(err)
      d.resolve();
    }); // copies directory, even if it has subdirectories or files
    return d.promise();
  };

  var writeCustomSettings = function(){
    var d = new $.Deferred;
    var renderer = ECT({ root : path.join(__dirname, '/template/') });

    var port = $(':text[name="port"]').val();
    var root = $(':text[name="root"]').val();

    var data = {
      "port": port,
      "root": root
    };
    var out = renderer.render('nginx.conf.ect', data);
    var config_path = path.join(nginx_conf_dir, 'nginx.conf')
    fs.writeFile(config_path, out , function (err) {
      if (err) { throw err; }
      d.resolve();
    });
    return d.promise();
  };

  var stopNginx = function(){
    var d = new $.Deferred;
    exec('nginx -s stop', function(err, stdout, stderr){
      // if (err) { throw err; }
      d.resolve();
    });
    return d.promise();
  };

  var startNginx = function(){
    var d = new $.Deferred;
    var command = "nginx -p `pwd` -c "+path.join(nginx_conf_dir, 'nginx.conf')
    exec(command, function(err, stdout, stderr){
      if (err) { throw err; }
      logger.debug('nginx start!');
      d.resolve();
    });
    return d.promise();
  };

  copySettings()
    .then(writeCustomSettings)
    .then(stopNginx)
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
