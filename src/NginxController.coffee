command = require('./Command').getInstance()
logger  = require('./Logger').getInstance()

config  = require './config'

class NginxController
  constructor: ()->
    @ngx_pid_file = config.ngx_pid_file
    @ngx_port     = config.ngx_port
    @ngx_root     = config.ngx_root

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
