command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

config  = require './config'

class MysqlController
  constructor: ()->

  @getInstance = ->
    @instance = new MysqlController() if !@instance?
    return @instance

  start: ()->
    logger.debug("MysqlController:start")
    command.run("mysql.server start")

  stop: ()->
    logger.debug("MysqlController:stop")
    command.run("mysql.server stop")

module.exports = MysqlController
