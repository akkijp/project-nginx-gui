fs = require 'fs'
Error = require './Error'

class FileWriter
  constructor: (@path)->
    @fd = fs.openSync(@path, 'w')

  write: (str)->
    self = @
    fs.writeSync(self.fd, str)

  close: ()->
    fs.closeSync(@fd)

# fileWriter = new FileWriter("./out.txt")
# fileWriter.write("aaa")
# fileWriter.close()
