# Description:
#   global functions
#
# Dependencies:
#
# Commands:

module.exports = (robot) ->
  class Saltstack

    url: (suffix) ->
      apiUrl = process.env.HUBOT_SALT_SERVERS_API_URL
      return apiUrl + suffix

    profile: (serverSize) ->
      return process.env.HUBOT_SALT_SERVERS_PROFILE_BASE + serverSize

    postBody: (bodyObj) ->
      bodyObj.username = process.env.HUBOT_SALT_SERVERS_USERNAME
      bodyObj.password = process.env.HUBOT_SALT_SERVERS_PASSWORD
      bodyObj.eauth = 'pam'
      bodyObj.client = 'local'
      bodyObj.tgt = process.env.HUBOT_SALT_SERVERS_MINION

      return JSON.stringify(bodyObj)

    robot.saltstack = new Saltstack
