command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

config  = require './config'

class PhpFpmController
  constructor: ()->

  @getInstance = ->
    @instance = new PhpFpmController() if !@instance?
    return @instance

  start: (callback)->
    onFulfilled = (stdout)->
      logger.debug("PhpFpmController:start")
      callback()
    onRejected = (stderr)->
      callback(stderr)
    command.run("php56-fpm start")
      .then(onFulfilled, onRejected)
    this

  stop: (callback)->
    onFulfilled = (stdout)->
      logger.debug("PhpFpmController:stop")
      callback()
    onRejected = (stderr)->
      callback(stderr)
    command.run("php56-fpm stop")
      .then(onFulfilled, onRejected)
    this

module.exports = PhpFpmController
