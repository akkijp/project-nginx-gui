fs = require 'fs'

class FileWriter
  constructor: (@path)->
    @fd = fs.openSync(@path, 'w')

  write: (str)->
    self = @
    fs.writeSync(self.fd, str)

  close: ()->
    fs.closeSync(@fd)

module.exports = FileWriter

# fileWriter = new FileWriter("./out.txt")
# fileWriter.write("aaa")
# fileWriter.close()
