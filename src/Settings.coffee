FileReader = require './FileReader'
__         = require 'underscore'

class Settings
  constructor: (@path)->
    @config = {
      "ngx_port": 8080,
      "ngx_root": process.env.HOME,
    }
    @read() if @path?


  getConfig: (key)->
    return @config[key]

  setConfig: (key, value)->
    @config[key] = value

  setPath: (@path)->

  write: ()->
    if @path?
      fileWriter = new FileWriter(@path)
      json = JSON.stringify(@config, null, '    ')
      fileWriter.write(json)
      fileWriter.close()
    else
      throw new Error("Settings: should be set path!")

  read: ()->
    if @path?
      fileReader = new FileReader(@path)
      json = JSON.parse(fileReader.read())
      @config = __.extend(@config, json)
    else
      throw new Error("Settings: should be set path!")

  bind: (selector, key, callback)->
    self = @
    input_text = document.querySelector(selector)
    input_text.addEventListener "keyup", ->
      self.config[key] = input_text.value
      callback()


module.exports = Settings

# JSON.parse(json)
# JSON.stringify(json, null, '    ')

# settings = new Settings()
# console.log(settings)
# settings.setPath("out.json")
# settings.read()
# console.log(settings)
