logger   = require('./Logger').getInstance()

###---------------------------
Error Handler
-----------------------------###
# from http://www.yoheim.net/blog.php?q=20121014
printStackTrace = (e) ->
  if e.stack?
    # 出力方法は、使いやすいように修正する。
    logger.fatal(e.stack)
  else
    # stackがない場合にsは、そのままエラー情報を出す。
    logger.fatal(e.message, e)

###---------------------------
  Error handling
  from http://www.yoheim.net/blog.php?q=20131102
-----------------------------###
process.on 'uncaughtException', (e) ->
  printStackTrace(e)

###---------------------------
End of Error Handler
-----------------------------###
