Command = require './Command'
command = Command.getInstance()

class NginxController
  constructor: (@settings_class)->
    defo = {
      "ngx_port": 8080,
      "ngx_root": process.env.HOME
    }
    # do something

  @getInstance = ->
    @instance = new NginxController() if !@instance?
    return @instance

  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = NginxController
