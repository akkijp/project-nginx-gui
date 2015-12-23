###
 入力された文字列の書式が不適切な場合に使用する例外オブジェクト。
 from http://tomoyamkung.net/2014/05/22/javascript-error-object/
 @param {String} message 例外エラーメッセージ。メッセージを指定しない場合はデフォルトのメッセージを設定する。
 from http://chaichan.lolipop.jp/qa4000/qa4478.htm
   https://www.nczonline.net/blog/2009/03/03/the-art-of-throwing-javascript-errors/
   https://www.joyent.com/developers/node/design/errors
   http://stackoverflow.com/questions/31089801/extending-error-in-javascript-with-es6-syntax
###
class BaseError extends Error
  constructor: (@message) ->
    super @message
    @name = @constructor.name
    Error.captureStackTrace(@, @name);

class ArgumentError extends BaseError
  constructor: (@message) ->
    super @message

class ExecuteError extends BaseError
  constructor: (@message) ->
    super @message

class IOError extends BaseError
  constructor: (@message) ->
    super @message

class FileNotFoundError extends IOError
  constructor: (@message) ->
    super @message
module.exports = {
  BaseError: BaseError,
  ArgumentError: ArgumentError,
  ExecuteError: ExecuteError,
  IOError: IOError,
  ArgumentError: ArgumentError,
  FileNotFoundError: FileNotFoundError,
}
