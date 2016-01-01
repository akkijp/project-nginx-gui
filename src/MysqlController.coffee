Command = require './Command'
command = Command.getInstance()

class MysqlController
  constructor: (@settings_class)->
    defo = {
    }
    # do something

  @getInstance = ->
    @instance = new MysqlController() if !@instance?
    return @instance

  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = MysqlController
