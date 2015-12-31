FileWriter = require './FileWriter'

class Settings
  constructor: (@path)->
    @config = {
      "ngx_port": 8080,
      "ngx_root": process.env.HOME,
    }
    @fileWriter = new FileWriter()

  getConfig: (key)->
    return @config[key]

  setConfig: (key, value)->
    @config[key] = value

  setPath: (@path)->

  write: ()->
    if @path?
      fileWriter = new FileWriter()
      json = JSON.stringify(@config, null, '    ')
      fileWriter.write(json)
    else
      throw new Error("Settings: should be set path!")

  read: (path)->
    # do something

module.exports = Settings

# JSON.parse(json)
# JSON.stringify(json, null, '    ')

# settings = new Settings("./out.json")
# settings.write()
