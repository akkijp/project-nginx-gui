
# Public: #console などにログを出力するためのハンドラークラス
#   このクラスは、Logger class の setHandlerメソッドにセットされ、
#   Logger class から呼び出されます。
#
# * `constructor`    none:
#
# Returns `LoggerConsoleHandler Class`.
class LoggerConsoleHandler
  constructor: ()->
    @console = document.querySelector("#console") if document?

  @getInstance = ->
    @instance = new LoggerConsoleHandler() if !@instance?
    return @instance

  console_scroll_top = ->
    console = document.querySelector("#console") if document?
    console.scrollTop = console.scrollHeight - console.clientHeight if document?

  debug: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"gray\">#{meg}</span></div>"
    @console.innerHTML = @console.innerHTML + html
    console_scroll_top()
  success: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"green\">#{meg}</span></div>"
    @console.innerHTML = @console.innerHTML + html
    console_scroll_top()
  info: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"skyblue\">#{meg}</span></div>"
    @console.innerHTML = @console.innerHTML + html
    console_scroll_top()
  warn: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"yellow\">#{meg}</span></div>"
    @console.innerHTML = @console.innerHTML + html
    console_scroll_top()
  fatal: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"red\">#{meg}</span></div>"
    @console.innerHTML = @console.innerHTML + html
    console_scroll_top()

  # private: 整形された日付を返します
  #
  # * `date`    (optional) Date Inctance (default: new Date()):
  #   その時刻でフォーマットされた日付を返します。
  #
  # Returns `String`. (example: `[16 Jan 1 3:29:42] debug`)
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

module.exports = LoggerConsoleHandler
