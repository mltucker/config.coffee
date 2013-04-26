# Sample nodejs config file.
#
# require("config").production # => non-shared mutable production settings
# require("config").development # => non-shared mutable development settings
# require("config").current # => non-shared mutable settings (production or development or ? depending on NODE_ENV)
# require("config") # => shared immutable settings (production or development or ? depending on NODE_ENV)

# Set default environment.
process.env.NODE_ENV ||= "development"

class Settings
  constructor: () ->

Object.defineProperties Settings::,
  production:
    get: ->
      environment: "production"
      http:
        port: 1080
      postgres:
        connect: "tcp://user@localhost/db"
      secrets:
        cookie: "d1a15cfad2b54ffab8cdd9f15ae8e6a5"
      log:
        console: false
        file: "logs/production.log"
  development:
    get: ->
      environment: "development"
      http:
        port: 1081
      postgres:
        connect: "tcp://devuser@localhost/devdb"
      secrets:
        cookie: "4de0f6a7ba9c4aada2c90bbc57012ad0"
      log:
        console: true
        file: "logs/development.log"
  current:
    get: ->
      @[process.env.NODE_ENV]

# Recursive freeze helper.
freeze = (o) ->
  Object.freeze(o)
  for key, prop of o
    if o.hasOwnProperty(key) and typeof prop == "object"
      freeze(prop)

settings = new Settings()
for key, val of settings.current
  settings[key] = val
freeze(settings)

module.exports = settings

