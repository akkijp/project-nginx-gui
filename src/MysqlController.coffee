command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

config  = require './config'

class MysqlController
  constructor: ()->

  @getInstance = ->
    @instance = new MysqlController() if !@instance?
    return @instance

  start: (callback)->
    onFulfilled = (stdout)->
      logger.debug("MysqlController:start")
      callback()
    onRejected = (stderr)->
      callback(stderr)
    command.run("mysql.server start")
      .then(onFulfilled, onRejected)
    this

  stop: (callback)->
    onFulfilled = (stdout)->
      logger.debug("MysqlController:stop")
      callback()
    onRejected = (stderr)->
      callback(stderr)
    command.run("mysql.server stop")
      .then(onFulfilled, onRejected)
    this

module.exports = MysqlController
