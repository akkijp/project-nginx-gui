fs      = require 'fs'
path    = require 'path'
os      = require 'os'
exec    = require('child_process').exec
Promise = require 'promise'
Error   = require './Error'
logger   = require('./Logger').getInstance()
PlatformUndefinedError = Error.PlatformUndefinedError
ExecuteError           = Error.ExecuteError
CommandNotFoundError   = Error.CommandNotFoundError

###
  command の絶対パスを取得するためのクラス
###
class Command

  constructor: ()->
    PATH_SEPARATOR = _getSeparator()
    env_path_list = _getEnvPathList(PATH_SEPARATOR).reverse()
    envPaths = env_path_list.concat(default_paths)
    @commandsSet = _getCommandsSet(envPaths, PATH_SEPARATOR)

  default_paths = [
    "/usr/local/sbin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
  ]

  @getInstance = ->
    @instance = new Command() if !@instance?
    return @instance

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

  run: (command, callback)->
    throw new CommandNotFoundError() if !command?
    cmds = command.split(/ +?/)
    cmd_path = @getCommandPath(cmds[0])
    cmd_args = cmds.slice(1).join(" ")
    command = "#{cmd_path} #{cmd_args}"
    # console.log("#{cmd_path} #{cmd_args}")
    throw new CommandNotFoundError() if !(cmd_path && cmd_path.trim())
    promise = new Promise (resolve, reject)->
      child = exec command, (error, stdout, stderr)->
        if error?
          reject(stderr)
          throw new ExecuteError()
        resolve(stdout)
        # console.log('stdout: ' + stdout);
        # console.log('stderr: ' + stderr);
    return promise

module.exports = Command


# command = Command.getInstance()
# command.run "nginx", ()->
#   console.log("done")
