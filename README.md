# README

The app is [hosted on heroku](https://guess-my-top-ten.herokuapp.com/)

### Concept
I recently completely a take home project very similar to this one, so I decided to spice
it up a bit. Instead of sending off a search and it just being forwarded to some
third party api, I made a little game. Admittedly not a very functional or even
fun game.

Instead of searching, you guess at my top ten favorites in a category. The two
categories are `music` and `video games`. I took some variants of names into
account. For instance, The Beatles are one of my favorite bands, so if you
supply the term `beatles` or `the beatles` or even `george harrison`, it will
count as correct.

Having said that, there's not really much to it. You guess. If you are wrong the
result will be a random freebie of the remaining answers. I could make it more
interesting by providing vague hints about the publisher or genre or something,
but I thought this would keep it speedy testing out the actual different
scenarios.

### Features
Of the requested features I have:
* A README
* A table called guesses that has a scoped uniqueness constraint
* RESTful endpoints
* Very basic sorting and filtering
* Valid JSON
* Robust error handling
* Request specs focused on unhappy paths
* Slightly optimized database queries
* Response and request caching
* Request signing with HMAC (instructions below)
* User creation and guessing counts separate for "authenticated" users and anonymous users alike

### API Documentation
Instead of adding living documentation with swagger or something (which I have
done until my eyes bleed), here are a list of documented endpoints:

[Guesses](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/B12c_599v)
[Categories](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/HkyZ695qP)
[Users](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/r1bRa995w)
[Errors](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/HkTuJj99D)
[Answers](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/B1FSSc5qv) USE THIS TO CHEAT, you cheater


### Users and Request Signing

To create a user, follow the API documentation above. Keep in mind Keys are only
available in the response to the /user POST response. Write it down or make
another user. On subsequent calls add the query parameter `user_name=`

If you intend to try out request signing, do something like this in a Ruby terminal:

```ruby
body = {
term: 'the beatles',
category: 'music',
}

signed_message = body.to_json + ':' + my_public_key
Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', my_private_key,
signed_message))
```

#### IMPORTANT
You can override the pesky request signing feature by using the header `Authorization=nah`
