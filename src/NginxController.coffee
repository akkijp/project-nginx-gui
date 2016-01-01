command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

class NginxController
  constructor: (@settings_class)->
    defo = {
      "pid_file": ""
      "ngx_port": 8080,
      "ngx_root": process.env.HOME
    }
    # do something

  @getInstance = ->
    @instance = new NginxController() if !@instance?
    return @instance

  start: ()->
    logger.debug("NginxController:start")
    # do something
  stop: ()->
    logger.debug("NginxController:stop")
    # do something

module.exports = NginxController
