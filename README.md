Saucisse
========
A tiny Node.js module to share on social networks

Only have a few simple commands
Create a new instance 

`saucisse = new Saucisse(myConfig)`

Post a tweet

`saucisse.tweet "This is a saucisse tweet", console.log`

Post a facebook message

`saucisse.fb "This is a saucisse facebook message", console.log`


Dependencies
------------
We need an oauth authentication library to authenticate on twitter API.

```coffeescript
Oauth = require('oauth').OAuth
https = require 'https'
```

Let's do it
-----------
Our main module class *Saucisse*

```coffeescript
class Saucisse
  constructor: (options = {}) ->
    @options = options
```

## Configuration part

There's a lot of configuration happening there

To get an app access token for facebook, cf : [Publishing with an access token](https://developers.facebook.com/docs/opengraph/howtos/publishing-with-app-token/)

```coffeescript
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
```


## twitter methods

### Send a tweet.
Just take the text of the tweet as a parameter

```coffeescript
  tweet : (text, done) =>
    data = status : text
    @twitterOauth.post(
      'http://api.twitter.com/1/statuses/update.json', 
      @options.twitter.access_token,
      @options.twitter.access_token_secret,
      data,
      ((err, resp) -> done(err, JSON.parse(resp)))
    )
```


## fb methods

### Send a facebook message.
on the graphid configured for this instance
Just take the text as a parameter

```coffeescript
  fb : (text, done) =>
    postData = "message=#{encodeURIComponent(text)}"
    postData += "&access_token=#{@options.facebook.access_token}"
    opts = 
      host   : "graph.facebook.com"
      port   : 443 
      path   : "/#{@options.facebook.graph_id}/feed"
      method : "POST"
      headers:
        'Content-Type'   : 'application/x-www-form-urlencoded'
        'Content-Length' : postData.length

    req = https.request opts, (res) ->
      res.setEncoding 'utf-8'
      res.on 'data', (chunk) ->
        done null, JSON.parse(chunk)
   
    req.write postData
    req.end()
```



Public methods
---------------

```coffeescript
module.exports = Saucisse
```

