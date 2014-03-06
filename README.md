# Client Cabinet

## API

### Get full user info

Method: POST

URL: /users/token

#### Summary

Find user by token and respond with JSON that contains full information about this user. This request can take a while. Use its lightweight version if performance is critical.

        { "id":"1-1LOG0C",
          "name":"Не определено Не определено",
          "phone":"+71111111114",
          "ogrn":"1127746082903",
          "created_at":"2014-02-24T14:47:08+04:00" }

#### Params

* `token`   `String`    Auth token

#### Response codes
* `200`   ok
* `500`   error occured

### Get basic user info

Method: POST

URL: /users/token_light

#### Summary

Find user by token and respond with JSON that contains only name and phone. Works much faster than previous method.

        { "name":"Не определено Не определено",
          "phone":"+71111111114" }

#### Params

* `token`   `String`    Auth token

#### Status code
* `200`   ok
* `500`   error occured

## Development

OGRN example

    1127746082903
