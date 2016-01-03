command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

settings = require('./Settings').getInstance()

class PhpFpmController
  constructor: ()->

  @getInstance = ->
    @instance = new PhpFpmController() if !@instance?
    return @instance

  start: (callback)->
    phpfpm_status_element = document.querySelector("#php-fpm_status img") if document?
    onFulfilled = (stdout)->
      logger.success("PhpFpmController:start")
      phpfpm_status_element.src = "./images/icon_green.png" if document?
      callback()
    onRejected = (stderr)->
      phpfpm_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    command.run("php56-fpm start")
      .then(onFulfilled, onRejected)
    this

  stop: (callback)->
    phpfpm_status_element = document.querySelector("#php-fpm_status img") if document?
    onFulfilled = (stdout)->
      logger.success("PhpFpmController:stop")
      phpfpm_status_element.src = "./images/icon_empty.png" if document?
      callback()
    onRejected = (stderr)->
      phpfpm_status_element.src = "./images/icon_red.png" if document?
      callback(stderr)
    command.run("php56-fpm stop")
      .then(onFulfilled, onRejected)
    this

module.exports = PhpFpmController
