class LoggerHandler
  debug: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"gray\">#{meg}</span></div>"
  success: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"green\">#{meg}</span></div>"
  info: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"skyblue\">#{meg}</span></div>"
  warn: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"yellow\">#{meg}</span></div>"
  fatal: (meg) ->
    html = "<div class=\"line\">#{_getFormattedDate()} <span class=\"red\">#{meg}</span></div>"

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

module.exports = LoggerHandler
