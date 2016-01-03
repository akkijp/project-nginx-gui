command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

config  = require './config'

class MysqlController
  constructor: ()->
    @mysql_pid_file = config.mysql_pid_file

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
