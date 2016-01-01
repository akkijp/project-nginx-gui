command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

class MysqlController
  constructor: (@settings_class)->
    defo = {
    }
    # do something

  @getInstance = ->
    @instance = new MysqlController() if !@instance?
    return @instance

  start: ()->
    logger.debug("MysqlController:start")
    # do something
  stop: ()->
    logger.debug("MysqlController:stop")
    # do something

module.exports = MysqlController
