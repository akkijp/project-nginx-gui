command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

config  = require './config'

class MysqlController
  constructor: ()->

  @getInstance = ->
    @instance = new MysqlController() if !@instance?
    return @instance

  start: (callback)->
    mysql_status_element = document.querySelector("#mysql_status img") if document?
    onFulfilled = (stdout)->
      logger.success("MysqlController:start")
      mysql_status_element.src = "./images/icon_green.png" if document?
      callback()
    onRejected = (stderr)->
      mysql_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    command.run("mysql.server start")
      .then(onFulfilled, onRejected)
    this

  stop: (callback)->
    mysql_status_element = document.querySelector("#mysql_status img") if document?
    onFulfilled = (stdout)->
      logger.success("MysqlController:stop")
      mysql_status_element.src = "./images/icon_empty.png" if document?
      callback()
    onRejected = (stderr)->
      mysql_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    command.run("mysql.server stop")
      .then(onFulfilled, onRejected)
    this

module.exports = MysqlController
