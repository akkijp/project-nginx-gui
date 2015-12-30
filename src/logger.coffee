Error = require './error'
ArgumentError = Error.ArgumentError

class Logger
  @DEBUG   = 0
  @SUCCESS = 1
  @INFO    = 2
  @WARN    = 3
  @FATAL   = 4

  constructor: ()->
    @level = Logger.DEBUG

  setLevel: (@level)->
    throw new ArgumentError("shuld be '0 <= level < =4'") if @level < 0 or 4 < @level

  getLevel: ()->
    @level

  debug: (msg)->
    if @level <= Logger.DEBUG
      formated_date = _getFormattedDate()
      console.log("#{formated_date} #{msg}")

  success: (msg)->
    if @level <= Logger.SUCCESS
      formated_date = _getFormattedDate()
      console.log("#{formated_date} %c#{msg}%c", 'color: green;', '')

  info: (msg)->
    if @level <= Logger.INFO
      formated_date = _getFormattedDate()
      console.log("#{formated_date} %c#{msg}%c", 'color: #00bcd4;', '')

  warn: (msg)->
    if @level <= Logger.WARN
      formated_date = _getFormattedDate()
      console.log("#{formated_date} %c#{msg}%c", 'color: #ffd700;', '')

  fatal: (msg)->
    if @level <= Logger.FATAL
      formated_date = _getFormattedDate()
      console.error("#{formated_date} %c#{msg}%c", 'color: red;', '')

  log: (level, msg)->
    self = @
    switch level
      when self.DEBUG
        Logger.debug(msg)
      when self.SUCCESS
        Logger.success(msg)
      when self.INFO
        Logger.info(msg)
      when self.WARN
        Logger.warn(msg)
      when self.FATAL
        Logger.fatal(msg)

  _getFormattedDate = do ->
    months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    return (date)->
      date = date || new Date()
      yy  = date.getFullYear().toString().slice(-2)
      m  = date.getMonth()
      dd  = date.getDate()
      HH = date.getHours()
      mm = date.getMinutes()
      ss = date.getSeconds()
      "[#{yy} #{months[m]} #{dd} #{HH}:#{mm}:#{ss}]"

  getFormattedDate: ()->
    _getFormattedDate()

logger = new Logger()
logger.setLevel(1)
logger.debug("debug")
logger.fatal("fatal")
logger.setLevel(5)
logger.debug("debug")
logger.warn("warn")
logger.fatal("fatal")
