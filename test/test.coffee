_ = require("underscore")
should = require("should")

config = require("../config")

# Check for required parameters in a configuration object.
confcheck = (conf) ->
  should.exist(conf.environment)
  should.exist(conf.http.port)
  should.exist(conf.postgres.connect)
  should.exist(conf.secrets.cookie)
  should.exist(conf.log.console)
  should.exist(conf.log.file)

suite "config", () ->
  test "should work", () ->
    config = require("../config")
    confcheck(config)

  test "should be immutable", () ->
    config = require("../config")
    env = config.environment
    config.environment = "not #{env}"
    config.environment.should.equal(env)
    port = config.http.port
    config.http.port = 1 + port
    config.http.port.should.equal(port)

  suite "#production", () ->
    test "should work", () ->
      config = require("../config").production
      confcheck(config)

    test "should be mutable", () ->
      config = require("../config").production
      env = config.environment
      config.environment = "not #{env}"
      config.environment.should.not.equal(env)
      port = config.http.port
      config.http.port = 1 + port
      config.http.port.should.not.equal(port)

    test "should not be shared", () ->
      p1 = require("../config").production
      p2 = require("../config").production
      port = p1.http.port
      p1.http.port++
      p1.http.port.should.not.equal(port)
      p2.http.port.should.equal(port)

  suite "#development", () ->
    test "should work", () ->
      config = require("../config").development
      confcheck(config)

  suite "#current", () ->
    test "should match environment", () ->
      current = require("../config").current
      if process.env.NODE_ENV == "development"
        current.should.eql(require("../config").development)
      else if process.env.NODE_ENV == "production"
        current.should.eql(require("../config").production)

