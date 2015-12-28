getHome = ->
  return process.env.USERPROFILE if process.platform is "win32"
  return process.env.HOME

nconf = require('nconf').file {file: getHome() + "/.bibteximport-config.json"}

module.exports=
  setConf: (key, value) ->
    nconf.set key, value
    nconf.save()
  getConf: (key) ->
    nconf.load()
    return nconf.get key
