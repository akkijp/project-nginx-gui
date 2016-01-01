Command = require './Command'
command = Command.getInstance()

class MysqlController
  constructor: (@settings_class)->
    defo = {
    }
    # do something
  start: ()->
    command.run()
  stop: ()->
    # do something

module.exports = MysqlController
