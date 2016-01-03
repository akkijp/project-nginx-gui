path    = require("path")
os      = require("os")

# src
configs_src    = path.join(__dirname, '/nginx-gui.d/')

# dist
# configs_dist = path.join(process.env.HOME, '/.nginx-gui.d/')
configs_dist = path.join(os.tmpDir(), '/.nginx-gui.d/')
app_config   = path.join(configs_dist, "settings.json")
ngx_configs  = path.join(configs_dist, '/nginx.d/')

ngx_pid_file   = path.join(configs_dist, "nginx.pid")
mysql_pid_file = path.join(configs_dist, "mysql.pid")

module.exports = {
  "configs_src":  configs_src,
  "configs_dist": configs_dist,
  "app_config":   app_config,
  "ngx_configs":  ngx_configs,

  "ngx_pid_file": ngx_pid_file,
  "ngx_port":     8080,
  "ngx_root":     process.env.HOME,

  "mysql_pid_file": mysql_pid_file,
}
