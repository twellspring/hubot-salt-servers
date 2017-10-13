# Hubot: Salt Servers

Create Create servers through saltstack

## Installation

Run the following command to install this module as a Hubot dependency

```
$ npm install hubot-salt-servers --save
```

Add the **hubot-salt-servers** to your `external-scripts.json` (you may need to create this file).

```
["hubot-salt-servers"]
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
