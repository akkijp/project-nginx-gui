remote  = require 'remote'
util    = remote.require("util")
path    = remote.require("path")
os      = remote.require("os")

require './ErrorHandler'

settings = require('./Settings').getInstance()
logger   = require('./Logger').getInstance()

nginx_controller  = require('./NginxController').getInstance()
mysql_controller  = require('./MysqlController').getInstance()
phpfpm_controller = require('./PhpFpmController').getInstance()

settings.bind('input[name="port"]', "ngx_port", (val)->
  logger.debug(val)
)
settings.bind('input[name="root"]', "ngx_root", (val)->
  logger.debug(val)
)

# for i in [0..20]
#   logger.debug("debug")

button = document.querySelector("#nginx_btn")
do ->
  isClicked = false
  button.addEventListener("click", ()->
    if isClicked
      nginx_controller.stop()
      mysql_controller.stop()
      phpfpm_controller.stop()
    else
      nginx_controller.start()
      mysql_controller.start()
      phpfpm_controller.start()
    isClicked = !isClicked
    this
  )

# logger.debug(settings.getConfig("ngx_port"))
# new NginxController()
# logger.debug(settings.getConfig("ngx_port"))

"none"
