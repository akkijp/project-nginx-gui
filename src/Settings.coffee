class Settings
  constructor: ()->
    @config = {
      "ngx_port": 8080,
      "ngx_root": process.env.HOME,
    }

  getConfig: (key)->
    return @config[key]

  setConfig: (key, value)->
    @config[key] = value

  write: ()->
    # do something
