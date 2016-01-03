path    = require 'path'
fs      = require 'fs-extra'
__      = require 'underscore'
Promise = require 'promise'
command = require('./Command').getInstance()
logger  = require('./Logger').getInstance()
FileReader = require('./FileReader')

config  = require './config'

class NginxController
  constructor: ()->

  @getInstance = ->
    @instance = new NginxController() if !@instance?
    return @instance

  startBefore: (callback)->
    promise1 = new Promise (resolve, reject)->
      # nginx.conf の構築
      src  = path.join(config.configs_src,  "nginx.d/nginx.conf.ust")
      dist = path.join(config.configs_dist, "nginx.d/nginx.conf")

      try
        file_reader = new FileReader src
        template_src = file_reader.read()
        file_reader.close()
      catch error
        reject(error)


      compiled = __.template(template_src)
      nginx_config = compiled({
        "port": config.ngx_port,
        "root": config.ngx_root,
      })

      fs.writeFileSync(dist, nginx_config, 'utf8')
      resolve()
      this

    promise2 = new Promise (resolve, reject)->
      src  = path.join(config.configs_src,  "nginx.d/")
      dist = path.join(config.configs_dist, "nginx.d/")
      # todo copy other config files
      logger.debug(dist)
      try
        fs.copySync(src, dist)
        resolve()
      catch error
        reject(error)

      this
    Promise.all([promise1, promise2]).nodeify(callback)

  start: ()->
    logger.debug("NginxController:start")
    nginx_config_path= path.join(config.configs_dist, "nginx.d/nginx.conf")
    @startBefore ()->
      command.run("nginx -c #{nginx_config_path}", ()->
        logger.debug("NginxController:start:done")
      )
    this

  stop: ()->
    logger.debug("NginxController:stop")
    command.run("nginx -s stop")
    logger.debug("NginxController:stop:done")
    # do something
    this

module.exports = NginxController
