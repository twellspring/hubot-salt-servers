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

  robot.respond /destroy server ([\w-]+)/i, (msg) ->
    return if robot.saltstack.restrictCommand(msg,  ["developer","qa"])
    serverName = msg.match[1]
    saltURL = robot.saltstack.url('/run')

    bodyObj =
      fun: 'cloud.destroy'
      arg: [ serverName ]
    body = robot.saltstack.postBody(bodyObj)

    robot.logger.info "Destroying server #{serverName}"

    msg.http(saltURL)
      .headers('Content-Type': 'application/json')
      .post(robot.saltstack.postBody(bodyObj)) (err, res, body) ->
        try
          if res.statusCode == 200
            msg.reply "Server #{serverName} has been destroyd"
            robot.logger.info "destroy server #{serverName} RC: #{res.statusCode} Body: #{body}"
          else
            msg.reply "Server #{serverName} destruction encountered an error."
            robot.logger.error "destroy server #{serverName} RC: #{res.statusCode} Body: #{body} ERR: #{JSON.stringify(err,null,2)}"
        catch error
          msg.reply "Salt API command errored."
          robot.logger.error "terminante server #{serverName} ERROR CATCH #{JSON.stringify(err,null,2)}"

  # Example based on a highstate using the pillar value "branch" as the branch to deploy to a server
  # Another option would be to use a state.sls and run a deploy state instead of using highstate
  robot.respond /update server ([\w-]+)( branch )?([\w-/\.]+)?/i, (msg) ->
    return if robot.saltstack.restrictCommand(msg,  ["developer","qa"])
    serverName = msg.match[1]
    serverBranch = msg.match[3] ? "master"
    saltURL = robot.saltstack.url('/run')

    bodyObj =
      fun: 'state.apply'
      arg: [ serverName ]
      kwarg:
        pillar:
          branch: serverBranch
    body = robot.saltstack.postBody(bodyObj)

    robot.logger.info "Update server #{serverName} to branch #{serverBranch}"

    msg.http(saltURL)
      .headers('Content-Type': 'application/json')
      .post(robot.saltstack.postBody(bodyObj)) (err, res, body) ->
        try
          if res.statusCode == 200
            msg.reply "Server #{serverName} has been destroyd"
            robot.logger.info "destroy server #{serverName} RC: #{res.statusCode} Body: #{body}"
          else
            msg.reply "Server #{serverName} destruction encountered an error."
            robot.logger.error "destroy server #{serverName} RC: #{res.statusCode} Body: #{body} ERR: #{JSON.stringify(err,null,2)}"
        catch error
          msg.reply "Salt API command errored."
          robot.logger.error "terminante server #{serverName} ERROR CATCH #{JSON.stringify(err,null,2)}"
