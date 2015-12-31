Command = require './Command'
command = new Command()

Settings = require './Settings'
settings = Settings.getInstance()

class NginxController
  constructor: (@settings_class)->
    # do something
  start: ()->
    # do something
  stop: ()->
    # do something

module.exports = NginxController
