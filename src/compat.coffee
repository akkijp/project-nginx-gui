os   = require("os")
fs   = require("fs")
path = require("path")
log = console.log

platform  = os.type()
isLinux   = platform is "Linux"
isDarwin  = platform is "Darwin"
isWindows = platform is "Windows_NT"

which = require('npm-which')(__dirname) # __dirname often good enough
pathToTape = which.sync('nginx')
console.log(pathToTape)

# PATH_SEPARATOR =　do ->
#   if isLinux or isDarwin
#     ":"
#   else if isWindows
#     ";"

# 先に現れたコマンドのパスを優先するので、リバースをして対応させている
# pathdirs = process.env.PATH.split(PATH_SEPARATOR).reverse()

# fs.access('/etc/passwd', fs.R_OK | fs.W_OK, (err) ->
#   console.log(err ? 'no access!' : 'can read/write');
# );

# for pathdir in pathdirs
#   isDirExists = fs.accessSync(pathdir, fs.R_OK)
#   log(1, isDirExists)
#   if isDirExists
#     files = fs.readdirSync pathdir
#     log(files)
#   else
#     return

#   isDirExists = fs.accessSync( pathdir, fs.F_OK)
#   # if isDirExists
#   #   fs.readdirSync(pathdir, (err, files)->
#   #     return if err?
#   #     p = path.join(pathdir, files)
#   #     log(files)
#   #   );
#   log(pathdir)
