remote  = require 'remote'
util    = remote.require("util")
path    = remote.require("path")
os      = remote.require("os")

require './ErrorHandler'

Command  = require './Command'
command  = new Command()

Settings = require './Settings'
settings = Settings.getInstance()

Logger   = require './Logger'
logger   = new Logger()

NginxController = require './NginxController'

# src
configs_dir   = path.join(__dirname, '/nginx-gui.d/');

# dist
# conf_path = path.join(process.env.HOME, '/.nginx-gui.d/');
conf_path = path.join(os.tmpDir(), '/.nginx-gui.d/');

app_conf_file  = path.join(conf_path, "settings.json");
nginx_conf_dir = path.join(conf_path, '/nginx.d/');


settings.bind('input[name="port"]', "ngx_port", (val)->
  logger.debug(val)
)
settings.bind('input[name="root"]', "ngx_root", (val)->
  logger.debug(val)
)

# for i in [0..20]
#   logger.debug("debug")

console_scroll_top = ->
  console = document.querySelector("#console")
  console.scrollTop = console.scrollHeight - console.clientHeight


# logger.debug(settings.getConfig("ngx_port"))
# new NginxController()
# logger.debug(settings.getConfig("ngx_port"))

"none"
