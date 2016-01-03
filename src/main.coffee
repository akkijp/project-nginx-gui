remote  = require 'remote'
util    = remote.require("util")
path    = remote.require("path")
os      = remote.require("os")
Promise = require 'promise'

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
      task1 = new Promise (resolve, reject)->
        nginx_controller.stop (error)-> if error? then reject() else resolve()
      task2 = new Promise (resolve, reject)->
        mysql_controller.stop (error)-> if error? then reject() else resolve()
      task3 = new Promise (resolve, reject)->
        phpfpm_controller.stop (error)-> if error? then reject() else resolve()
      Promise.all([task1, task2, task3]).then(()->
        logger.debug("done")
      )
    else
      task1 = new Promise (resolve, reject)->
        nginx_controller.start (error)-> if error? then reject() else resolve()
      task2 = new Promise (resolve, reject)->
        mysql_controller.start (error)-> if error? then reject() else resolve()
      task3 = new Promise (resolve, reject)->
        phpfpm_controller.start (error)-> if error? then reject() else resolve()
      Promise.all([task1, task2, task3]).then(()->
        logger.debug("done")
      )
    isClicked = !isClicked
    this
  )

# logger.debug(settings.getConfig("ngx_port"))
# new NginxController()
# logger.debug(settings.getConfig("ngx_port"))

"none"
