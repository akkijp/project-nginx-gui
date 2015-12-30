fs    = require 'fs'
path  = require 'path'
os    = require 'os'
Error = require './error'
PlatformUndefinedError = Error.PlatformUndefinedError

###
  command の絶対パスを取得するためのクラス
###
class Command

  constructor: ()->
    PATH_SEPARATOR = _getSeparator()
    envPaths = _getEnvPathList(PATH_SEPARATOR).reverse()
    @commandsSet = _getCommandsSet(envPaths, PATH_SEPARATOR)

  _getSeparator = ->
    platform  = os.type()
    isLinux   = platform is "Linux"
    isDarwin  = platform is "Darwin"
    isWindows = platform is "Windows_NT"
    if isLinux or isDarwin
      ":"
    else if isWindows
      ";"
    else
      throw new PlatformUndefinedError()

  _getEnvPathList = (path_separator)->
    env_path_str = process.env.PATH
    return env_path_str.split(path_separator)

  _isPathExist = (path)->
    try
      fs.accessSync(path, fs.R_OK)
      return true
    catch error
      return false

  _getFileNames = (path)->
    return fs.readdirSync(path)

  _getCommandsSet = (env_paths)->
    commands = {}
    for env_path in env_paths
      if _isPathExist(env_path)
        command_names = _getFileNames(env_path)
        for command_name in command_names
          command_path = path.join(env_path, command_name)
          commands[command_name] = command_path

    return commands

  ###
     @method getCommandPath(cmd)
       cmd: string コマンドの名前
     @return string コマンドに対するフルパス
  ###
  getCommandPath: (cmd)->
    return @commandsSet[cmd]

module.exports = Command
