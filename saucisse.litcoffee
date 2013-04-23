Saucisse
========
A tiny Node.js module to share on social networks

Only have a few simple commands
Create a new instance 

`saucisse = new Saucisse(myConfig)`

Post a tweet

`saucisse.tweet "This is a saucisse tweet", console.log`



Dependencies
------------
We need an oauth authentication library to authenticate on twitter API.


    Oauth = require('oauth').OAuth
    http  = require 'http'


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

        if options.facebook?
          throw new Error("Missing app access token") if not options.facebook.access_token?
          throw new Error("Missing facebook graph id") if not options.facebook.graph_id?
    

      tweet : (text, done) =>
        data = status : text
        @twitterOauth.post(
          'http://api.twitter.com/1/statuses/update.json', 
          @options.twitter.access_token,
          @options.twitter.access_token_secret,
          data,
          ((err, resp) -> done(err, JSON.parse(resp)))
        )


      facebookMessage : (text, done) =>
        postData = "message=#{encodeURIComponent(text)}&access_token=#{@options.facebook.access_token}"

        options = 
          host   : "graph.facebook.com"
          port   : 443
          path   : "/#{@options.facebook.graph_id}/feed"
          method : "POST"
          headers:
            'Content-Type'   : 'application/x-www-form-urlencoded'
            'Content-Length' : postData.length
       
        req = http.request option, (res) ->
          res.setEncoding 'utf-8'
          res.on 'data', (chunk) ->
            console.log chunk
            done null, chunk
       
        req.write postData
        req.end()



Public methods
---------------


    module.exports = Saucisse



    sc = new Saucisse 
      facebook:
        access_token: "BAAFDt8VGgj0BAJjZCD19YWOi9EGtwGKDh3Ikprtv1Hlo30hPyURkzShsEZBRoLhKkCteW1J4hQy9LdRGlp69iD5s1DMkfWpYcZAkMHjDnxg6wOuOqMaZAWVWtZBs7uW3X6tP8TMtNehce17ixPzI2XE8Ar00TimHD17FTODx9NWO7okBENLQZCxye8Gb0xxS0ZC2R3k95hC2WJyUxy9uqrZC"
        graph_id: '100003518167596'

    sc.facebookMessage "This is another test", (err, res) ->
      console.error err, res
