command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

class PhpFpmController
  constructor: (@settings_class)->
    defo = {
    }
    # do something

  @getInstance = ->
    @instance = new PhpFpmController() if !@instance?
    return @instance

  start: ()->
    logger.debug("PhpFpmController:start")
    # do something
  stop: ()->
    logger.debug("PhpFpmController:stop")
    # do something

module.exports = PhpFpmController
