# Client Cabinet

## API

### Get full user info

Method: POST

URL: /users/token/:token

#### Returns
JSON with full user info.

#### Status code
* `200`   ok
* `500`   error occured

#### Response example

        { "id":"1-1LOG0C",
        "name":"Не определено Не определено",
        "phone":"+71111111114",
        "ogrn":"1127746082903",
        "created_at":"2014-02-24T14:47:08+04:00" }

