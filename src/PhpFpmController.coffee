Command = require './Command'
command = Command.getInstance()

class PhpFpmController
  constructor: (@settings_class)->
    defo = {
    }
    # do something

  @getInstance = ->
    @instance = new PhpFpmController() if !@instance?
    return @instance

  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = PhpFpmController
