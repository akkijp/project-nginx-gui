fs = require 'fs'
Error = require './Error'
FileNotFoundError = Error.FileNotFoundError

class FileReader
  constructor: (@path)->
    try
      fs.accessSync(@path, fs.R_OK)
    catch error
      throw new FileNotFoundError(error)
    @fd = fs.openSync(@path, 'r')

  read: (callback)->
    return fs.readFileSync(@path, 'utf8', callback)

  close: ()->
    fs.closeSync(@fd)

module.exports = FileReader

# fileWriter = new FileReader("./ou.txt")
# console.log(fileWriter.read())
# fileWriter.close()
