Error = require './error'
ArgumentError = Error.ArgumentError

class Logger
  @DEBUG   = 0
  @SUCCESS = 1
  @INFO    = 2
  @WARN    = 3
  @FATAL   = 4

  _black   = '\u001b[30m'
  _red     = '\u001b[31m'
  _green   = '\u001b[32m'
  _yellow  = '\u001b[33m'
  _blue    = '\u001b[34m'
  _magenta = '\u001b[35m'
  _cyan    = '\u001b[36m'
  _white   = '\u001b[37m'

  _reset   = '\u001b[0m'

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
      console.log("#{formated_date} #{_green}#{msg}#{_reset}")

  info: (msg)->
    if @level <= Logger.INFO
      formated_date = _getFormattedDate()
      console.log("#{formated_date} #{_cyan}#{msg}#{_reset}")

  warn: (msg)->
    if @level <= Logger.WARN
      formated_date = _getFormattedDate()
      console.log("#{formated_date} #{_yellow}#{msg}#{_reset}")

  fatal: (msg)->
    if @level <= Logger.FATAL
      formated_date = _getFormattedDate()
      console.error("#{formated_date} #{_red}#{msg}#{_reset}")

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

module.exports = Logger

# logger = new Logger()
# logger.setLevel(Logger.DEBUG)
# logger.debug("debug")
# logger.success("success")
# logger.info("info")
# logger.warn("warn")
# logger.fatal("fatal")
