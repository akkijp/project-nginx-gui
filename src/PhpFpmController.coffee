command = require('./Command').getInstance()
logger   = require('./Logger').getInstance()

class PhpFpmController
  constructor: ()->

  @getInstance = ->
    @instance = new PhpFpmController() if !@instance?
    return @instance

  start: ()->
    logger.debug("PhpFpmController:start")
    command.run("php56-fpm start")

  stop: ()->
    logger.debug("PhpFpmController:stop")
    command.run("php56-fpm stop")

module.exports = PhpFpmController
