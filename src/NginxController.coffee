Command = require 'Command'
command = new Command()

class NginxController
  constructor: (@settings_class)->
  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = NginxController
