path    = require 'path'
fs      = require 'fs-extra'
__      = require 'underscore'
Promise = require 'promise'
command = require('./Command').getInstance()
logger  = require('./Logger').getInstance()
FileReader = require('./FileReader')

settings = require('./Settings').getInstance()

class NginxController
  constructor: ()->

  @getInstance = ->
    @instance = new NginxController() if !@instance?
    return @instance

  startBefore: (callback)->
    promise1 = new Promise (resolve, reject)->
      # nginx.conf の構築
      src  = path.join(settings.getConfig("configs_src"),  "nginx.d/nginx.conf.ust")
      dist = path.join(settings.getConfig("configs_dist"), "nginx.d/nginx.conf")

      try
        file_reader = new FileReader src
        template_src = file_reader.read()
        file_reader.close()
      catch error
        reject(error)


      compiled = __.template(template_src)
      nginx_config = compiled({
        "port": settings.getConfig("ngx_port"),
        "root": settings.getConfig("ngx_root"),
      })

      fs.writeFileSync(dist, nginx_config, 'utf8')
      resolve()
      this

    promise2 = new Promise (resolve, reject)->
      src  = path.join(settings.getConfig("configs_src"),  "nginx.d/")
      dist = path.join(settings.getConfig("configs_dist"), "nginx.d/")
      try
        fs.copySync(src, dist)
        resolve()
      catch error
        reject(error)

      this
    Promise.all([promise1, promise2]).nodeify(callback)

  start: (callback)->
    nginx_status_element = document.querySelector("#nginx_status img") if document?
    onFulfilled = (stdout)->
      logger.success("NginxController:start")
      nginx_status_element.src = "./images/icon_green.png" if document?
      callback()
    onRejected = (stderr)->
      nginx_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    nginx_config_path= path.join(settings.getConfig("configs_dist"), "nginx.d/nginx.conf")
    @startBefore ()->
      command.run("nginx -c #{nginx_config_path}")
        .then(onFulfilled, onRejected)
    this

  stop: (callback)->
    nginx_status_element = document.querySelector("#nginx_status img") if document?
    onFulfilled = (stdout)->
      logger.success("NginxController:stop")
      nginx_status_element.src = "./images/icon_empty.png" if document?
      callback()
    onRejected = (stderr)->
      nginx_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    command.run("nginx -s stop")
      .then(onFulfilled, onRejected)
    this

module.exports = NginxController
