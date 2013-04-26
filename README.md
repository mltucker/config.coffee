config.coffee
=============

A nodejs config file pattern which I find useful.

Main idea
---------

A good `require("./config")` should have:

* comments
* environment support
* immutability

Also useful:

* access configs non-current environment(s)
* config modification (e.g. for testing)

Usage
-----

Normal usage:

    config = require("./config")
    port = config.http.port # => 1080

This is a shared object which is immutable (`Object.freeze`):

    config = require("./config")
    original = config.http.port # => 1080
    config.http.port = original + 1
    assert(config.http.port == original) # OK

Production vs development environments:

    dconf = require("./config").development
    pconf = require("./config").production
    cconf = require("./config").current # => dev settings if process.env.NODE_ENV=="development"

These are mutable, and not-shared:

    dconf1 = require("./config").current
    dconf2 = require("./config").current

    original = dconf1.http.port # => 1080
    dconf1.http.port = original + 1
    assert(dconf1.http.port == original + 1) # OK
    assert(dconf2.http.port == original) # OK

Final thoughts
--------------

Since (some) configs can be modified, it is useful to use the default config as a default:

    class Server
      constructor: (@config) ->

    exports.start = (config=require("./config")) ->
      server = new Server(config)
      server.start()

Testing
-------

    make test

License
-------

MIT

