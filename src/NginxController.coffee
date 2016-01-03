command = require('./Command').getInstance()
logger  = require('./Logger').getInstance()

config  = require './config'

class NginxController
  constructor: (@settings_class)->
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
