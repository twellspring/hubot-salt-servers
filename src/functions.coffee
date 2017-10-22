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

    restrictCommand: (msg, allowedRoles) ->
        user = robot.brain.userForName(msg.message.user.name)
        return false if robot.auth.isAdmin(user) ||   
            robot.auth.hasRole(user, allowedRoles)

         msg.reply "You do not have the correct permission for that command."
         return true

    robot.saltstack = new Saltstack
