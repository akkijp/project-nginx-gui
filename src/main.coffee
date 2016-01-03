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
  settings.write()
)
settings.bind('input[name="root"]', "ngx_root", (val)->
  settings.write()
)

# for i in [0..20]
#   logger.debug("debug")

button = document.querySelector("#nginx_btn")
do ->
  isClicked = false
  button.addEventListener("click", ()->
    if isClicked
      onFulfilled = ()->
        logger.debug("done")
        button.classList.add("btn-primary")
        button.classList.remove("btn-danger")
        button.classList.remove("avoid-clicks")
        button.classList.remove("active")
        button.innerHTML = "Server Start"

      button.classList.add("avoid-clicks")
      button.classList.add("active")
      task1 = new Promise (resolve, reject)->
        nginx_controller.stop (error)-> if error? then reject() else resolve()
      task2 = new Promise (resolve, reject)->
        mysql_controller.stop (error)-> if error? then reject() else resolve()
      task3 = new Promise (resolve, reject)->
        phpfpm_controller.stop (error)-> if error? then reject() else resolve()
      Promise.all([task1, task2, task3]).then(onFulfilled, onFulfilled)
    else
      onFulfilled = ()->
        logger.debug("done")
        button.classList.add("btn-danger")
        button.classList.remove("btn-primary")
        button.classList.remove("avoid-clicks")
        button.classList.remove("active")
        button.innerHTML = "Server Stop"

      button.classList.add("avoid-clicks")
      button.classList.add("active")
      task1 = new Promise (resolve, reject)->
        nginx_controller.start (error)-> if error? then reject() else resolve()
      task2 = new Promise (resolve, reject)->
        mysql_controller.start (error)-> if error? then reject() else resolve()
      task3 = new Promise (resolve, reject)->
        phpfpm_controller.start (error)-> if error? then reject() else resolve()
      Promise.all([task1, task2, task3]).then(onFulfilled, onFulfilled)
    isClicked = !isClicked
    this
  )

# logger.debug(settings.getConfig("ngx_port"))
# new NginxController()
# logger.debug(settings.getConfig("ngx_port"))

"none"
