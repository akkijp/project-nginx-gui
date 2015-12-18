remote  = require 'remote'
util    = remote.require("util")
path    = remote.require("path")
exec    = remote.require('child_process').exec

$       = require("./js/lib/jquery-2.1.4.min.js")
ECT     = remote.require('ect')

# from https://github.com/jprichardson/node-fs-extra
fs      = remote.require('fs-extra')
# from https://www.npmjs.com/package/npm-which
which = require('npm-which')(__dirname) # __dirname often good enough

root = global.root = __dirname;

conf_path = path.join(process.env.HOME, '/.nginx-gui.conf.d/');

nginx_conf_dir = path.join(conf_path, '/nginx.d/');
app_conf_file  = path.join(conf_path, "settings.json");
template_dir   = path.join(__dirname, '/template/');


###
 入力された文字列の書式が不適切な場合に使用する例外オブジェクト。
 from http://tomoyamkung.net/2014/05/22/javascript-error-object/
 @param {String} message 例外エラーメッセージ。メッセージを指定しない場合はデフォルトのメッセージを設定する。
 from http://chaichan.lolipop.jp/qa4000/qa4478.htm
   https://www.nczonline.net/blog/2009/03/03/the-art-of-throwing-javascript-errors/
   https://www.joyent.com/developers/node/design/errors
   http://stackoverflow.com/questions/31089801/extending-error-in-javascript-with-es6-syntax
###
class BaseError extends Error
  constructor: (@message) ->
    super @message
    @name = @constructor.name
    Error.captureStackTrace(@, @name);

class ArgumentError extends BaseError
  constructor: (@message) ->
    super @message

class FileNotFoundError extends BaseError
  constructor: (@message) ->
    super @message

# from http://qiita.com/ktty1220/items/c89a0101ab4a87311637
# from http://stackoverflow.com/questions/11386492/accessing-line-number-in-v8-javascript-chrome-node-js
# Object.defineProperty(global, '__stack', {
#   get: ->
#     orig = Error.prepareStackTrace;
#     Error.prepareStackTrace = (_, stack)->stack
#     err = new Error;
#     Error.captureStackTrace(err, arguments.callee);
#     stack = err.stack;
#     Error.prepareStackTrace = orig;
#     stack;
# });
# Object.defineProperty(global, '__line', {
#   get: ->
#     __stack[1].getLineNumber();
# });

logger = {
  debug: (meg) ->
    dt = new Date();
    console.log("#{dt.toString()} #{meg}")
    $console_html = $("<div class=\"line gray\">#{dt.toString()} #{meg}</div>")
    $("#console_panel").append($console_html)
  success: (meg) ->
    dt = new Date();
    console.log("#{dt.toString()} %c#{meg}%c", 'color: green;', '')
    $console_html = $("<div class=\"line green\">#{dt.toString()} #{meg}</div>")
    $("#console_panel").append($console_html)
  info: (meg) ->
    dt = new Date();
    console.log("#{dt.toString()} %c#{meg}%c", 'color: #00bcd4;', '')
    $console_html = $("<div class=\"line skyblue\">#{dt.toString()} #{meg}</div>")
    $("#console_panel").append($console_html)
  warn: (meg) ->
    dt = new Date();
    console.log("#{dt.toString()} %c#{meg}%c", 'color: #ffd700;', '')
    $console_html = $("<div class=\"line yellow\">#{dt.toString()} #{meg}</div>")
    $("#console_panel").append($console_html)
  fatal: (meg) ->
    dt = new Date();
    console.error("#{dt.toString()} %c#{meg}%c", 'color: red;', '')
    $console_html = $("<div class=\"line red\">#{dt.toString()} #{meg}</div>")
    $("#console_panel").append($console_html)
}
log = logger.debug # alias

# from http://www.yoheim.net/blog.php?q=20121014
printStackTrace = (e) ->
  if e.stack?
    # 出力方法は、使いやすいように修正する。
    logger.fatal(e.stack)
  else
    # stackがない場合にsは、そのままエラー情報を出す。
    logger.fatal(e.message, e)

###---------------------------
  Error handling
  from http://www.yoheim.net/blog.php?q=20131102
-----------------------------###
process.on 'uncaughtException', (e) ->
  printStackTrace(e)

###---------------------------
  commands
-----------------------------###
# settings
pathToNginx   = which.sync('nginx')
pathToPhpfpm  = which.sync('php56-fpm')
pathToMysql   = which.sync('mysql.server')

# nginx
nginx = nginx || {}
nginx.start = ->
  d = new $.Deferred
  command = "#{pathToNginx} -p `pwd` -c #{path.join(nginx_conf_dir, 'nginx.conf')}"
  exec command, (err, stdout, stderr) ->
    $nginx_status = $("#nginx_status img")
    if err?
      $nginx_status.attr("src", "./images/icon_red.png") if $nginx_status?
      throw err
    $nginx_status.attr("src", "./images/icon_green.png") if $nginx_status?
    logger.debug('nginx start!')
    d.resolve()
  d.promise()

nginx.stop = ->
  d = new $.Deferred
  exec "#{pathToNginx} -s stop", (err, stdout, stderr) ->
    $nginx_status = $("#nginx_status img")
    if err?
      $nginx_status.attr("src", "./images/icon_red.png") if $nginx_status?
      throw err
    $nginx_status.attr("src", "./images/icon_empty.png") if $nginx_status?
    logger.debug('server stoped!')
    d.resolve()
  d.promise()


# php-fpm
phpfpm = phpfpm || {}
phpfpm.start = ->
  d = new $.Deferred;
  exec "#{pathToPhpfpm} start", (err, stdout, stderr) ->
    $phpfpm_status = $("#php-fpm_status img")
    if err?
      $phpfpm_status.attr("src", "./images/icon_red.png") if $phpfpm_status?
      throw err
    $phpfpm_status.attr("src", "./images/icon_green.png") if $phpfpm_status?
    logger.debug('php56-fpm start!')
    d.resolve()
  d.promise()

phpfpm.stop = ->
  d = new $.Deferred
  exec "#{pathToPhpfpm} stop", (err, stdout, stderr) ->
    $phpfpm_status = $("#php-fpm_status img")
    if err?
      $phpfpm_status.attr("src", "./images/icon_red.png") if $phpfpm_status?
      throw err
    $phpfpm_status.attr("src", "./images/icon_empty.png") if $phpfpm_status?
    logger.debug('php56-fpm stoped!')
    d.resolve()
  d.promise()

# mysql
mysql = mysql || {}
mysql.start = ->
  d = new $.Deferred;
  exec "#{pathToMysql} start", (err, stdout, stderr) ->
    $mysql_status = $("#mysql_status img")
    if err?
      $mysql_status.attr("src", "./images/icon_red.png") if $mysql_status?
      throw err
    $mysql_status.attr("src", "./images/icon_green.png") if $mysql_status?
    logger.debug('mysql start!')
    d.resolve()
  d.promise()

mysql.stop = ->
  d = new $.Deferred;
  exec "#{pathToMysql} stop", (err, stdout, stderr) ->
    $mysql_status = $("#mysql_status img")
    if err?
      $mysql_status.attr("src", "./images/icon_red.png") if $mysql_status?
      throw err
    $mysql_status.attr("src", "./images/icon_empty.png") if $mysql_status?
    logger.debug('mysql stop!')
    d.resolve()
  d.promise()

###---------------------------
  tasks
-----------------------------###

window.ngx_start   = nginx.start
window.ngx_stop    = nginx.stop
window.phpf_start  = phpfpm.start
window.phpf_stop   = phpfpm.stop
window.mysql_start = mysql.start
window.mysql_stop  = mysql.stop

"none"
