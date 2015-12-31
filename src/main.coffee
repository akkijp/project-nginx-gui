remote  = require 'remote'
util    = remote.require("util")
path    = remote.require("path")
os      = remote.require("os")

require './ErrorHandler'

Command  = require './Command'
command  = new Command()

Settings = require './Settings'
settings = new Settings()

Logger   = require './Logger'
logger   = new Logger()

# src
configs_dir   = path.join(__dirname, '/nginx-gui.d/');

# dist
# conf_path = path.join(process.env.HOME, '/.nginx-gui.d/');
conf_path = path.join(os.tmpDir(), '/.nginx-gui.d/');

app_conf_file  = path.join(conf_path, "settings.json");
nginx_conf_dir = path.join(conf_path, '/nginx.d/');


settings.bind('input[name="port"]', "ngx_port", (val)->
  # console.log(val)
)
settings.bind('input[name="root"]', "ngx_root", (val)->
  # console.log(val)
)

# logger.debug("debug")



console_scroll_top = ->
  $psconsole = $("#console");
  $psconsole.scrollTop($psconsole[0].scrollHeight - $psconsole.height())





"none"
