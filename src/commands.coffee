fs = require 'fs'
path = require 'path'
os = require 'os'

###
 @params none

###
class Command

  constructor: ()->
    PATH_SEPARATOR = _getSeparator()
    envPaths = _getEnvPathList(PATH_SEPARATOR).reverse()
    @commandsSet = _getCommandsSet(envPaths, PATH_SEPARATOR)

  _getSeparator = ->
    os_type = os.type()
    return ":" if os_type == "Linux" or os_type == "Darwin"
    return ";" if os_type == "Windows_NT"

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

cmd = new Command()
console.log(cmd.getCommandPath("node"))

# module.exports.getCommandPath = (command) ->
#   return commands_list[command]
