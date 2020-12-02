# README

This README would normally document whatever steps are necessary to get the
application up and running.


### API Documentation
Instead of adding living documentation with swagger or something, here are a
list of documented endpoints

[Guesses](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/B12c_599v)
[Categories](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/HkyZ695qP)
[Users](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/r1bRa995w)
[Errors](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/HkTuJj99D)
[Answers](https://hackmd.io/@3EsXNN0gSKqG4L5xr7fj1A/B1FSSc5qv) USE THIS TO CHEAT, you cheater


### Request signing

Use this in a ruby terminal

body = {
term: 'the beatles',
category: 'music',
}

key = body.to_json + ':' + my_public_key
Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', my_private_key, key))
