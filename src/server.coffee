# Description:
#   Server commands. Use the salt API
#
# Dependencies:
#   salt-api accessible from hubot server
#
#   hubot create server <server name> [size <t2.small|t2.medium|...>]
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

module.exports = (robot) ->

  robot.respond /create server ([\w-]+)( size )?([a-z]\d\.\w+)/i, (msg) ->
    return if robot.saltstack.restrictCommand(msg,  ["developer","qa"])
    serverName = msg.match[1]
    serverSize = msg.match[3] ? "t2.small"
    profile = robot.saltstack.profile(serverSize)
    saltURL = robot.saltstack.url('/run')

    bodyObj =
      fun: 'cloud.profile'
      arg: [ profile , serverName ]
    body = robot.saltstack.postBody(bodyObj)

    robot.logger.info "create server #{serverName} Started"
    msg.reply "Creating server #{serverName}.  This could take a few minutes."

    msg.http(saltURL)
      .headers('Content-Type': 'application/json')
      .post(robot.saltstack.postBody(bodyObj)) (err, res, body) ->
        try
          if res.statusCode == 200
            msg.reply "Server #{serverName} has been created"
            robot.logger.info "create server #{serverName} RC: #{res.statusCode} Body: #{body}"
          else
            msg.reply "Server #{serverName} creation encountered an error."
            robot.logger.error "create server #{serverName} RC: #{res.statusCode} Body: #{body} ERR: #{JSON.stringify(err,null,2)}"
        catch error
          msg.reply "Salt API command errored."
          robot.logger.error "create server #{serverName} ERROR CATCH #{JSON.stringify(err,null,2)}"
