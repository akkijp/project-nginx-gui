Command = require './Command'
command = new Command()

class NginxController
  constructor: (@settings_class)->
    defo = {
      "ngx_port", 8080,
      "ngx_root", process.env.HOME
    }
    # do something
  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = NginxController
