# Hubot: Salt Servers

Create servers through saltstack.  This is a functional example containing
commands to create, update and delete servers

## Installation

Run the following command to install this module as a Hubot dependency

```
$ npm install hubot-salt-servers --save
$ npm install hubot-auth --save
```

Add modules to your `external-scripts.json` (you may need to create this file).

```
[  "hubot-auth",
   "hubot-salt-servers"
]
```

## Configuration

credentials for the salt api are passed via environment variables.

```
HUBOT_SALT_SERVERS_API_URL='https://mysaltapi.mycompany.com'
HUBOT_SALT_SERVERS_USERNAME='hubotuser'
HUBOT_SALT_SERVERS_PASSWORD='hubotpassword'
HUBOT_SALT_SERVERS_MINION='myminion'
HUBOT_SALT_SERVERS_PROFILE_BASE='us-west-2a_dev_'

```

## Runtime configuration

This example restricts access to these commands to admins or members of the `qa`
or `developer` role.  See `help role` for how to add a slack user to a role.
