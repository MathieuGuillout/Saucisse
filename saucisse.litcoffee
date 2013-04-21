Saucisse
========
A tiny Node.js module to share on social networks

Only have a few simple commands
Create a new instance 

saucisse = new Saucisse(myConfig)

Post a tweet

saucisse.tweet "This is a saucisse tweet", console.log



Dependencies
------------
We need an oauth authentication library to authenticate on twitter API.


    Oauth = require('oauth').OAuth


Let's do it
-----------
Our main module class *Saucisse*


    class Saucisse
      constructor: (options = {}) ->
        @options = options
        if options.twitter?
          throw new Error("Missing twitter key") if not options.twitter.consumer_key?
          throw new Error("Missing twitter secret") if not options.twitter.consumer_secret?
          throw new Error("Missing twitter token") if not options.twitter.access_token?
          throw new Error("Missing twitter token secret") if not options.twitter.access_token_secret?
          
          @twitterOauth = new Oauth(
            'http://twitter.com/oauth/request_token',
            'http://twitter.com/oauth/access_token',
            @options.twitter.consumer_key,
            @options.twitter.consumer_secret, 
            '1.0A',
            null,
            'HMAC-SHA1'
          )
    

      tweet : (text, done) ->
        data = status : text
        @twitterOauth.post(
          'http://api.twitter.com/1/statuses/update.json', 
          @options.twitter.access_token,
          @options.twitter.access_token_secret,
          data,
          ((err, resp) -> done(err, JSON.parse(resp)))
        )





Public methods
---------------


    module.exports = Saucisse

    #CONFIG = require 'config'
    #saucisse = new Saucisse(CONFIG)
    #saucisse.tweet "test", (err, resp) -> 
    #  console.error err, resp
