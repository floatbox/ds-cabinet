# Client Cabinet

## Topics API

### Authentication

The API uses token based authentication. Only concierges could be authenticated.

Example of request header:

    Authorization: Token token=16d7d6089b8fe0c5e19bfe10bb156832

### Create topic

Method: POST

URL: /api/v1/users/:user_id/topics

#### Summary

Creates a topic by current user.

#### Params

This enpoint accepts JSON with the following structure:

    { "topic": {
        "widget_type":"purchase",
        "widget_options": {
          "domain":"http://...",
          "anything_else":""
        }
      }
    }

User should be specified as :user_id parameter in URL.

#### Response

* `201` Topic was successfully created. Serialized topic will be returned.
* `401` Bad credentials. There is no user with passed token, or this user is not concierge.
* `422` Invalid arguments. Array with errors will be returned.
* `500` Something went terribly wrong :(

## Users API

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

## Подготовка к работе с Oracle

Подключаемся к Oracle с помощью "ssh port binding" через "club.sredda.ru"

Прописываем хост в `~/.ssh/config`:

    Host sredda.ru
      HostName club.sredda.ru
      User u.sername

Открываем "ssh тунель":

    локальный порт : ip оракла : удаленный порт : сервер
    ssh -L 1521:178.159.249.26:1521 sredda.ru

## Авторизация

Для работы авторизации требуется чтобы сайт находился на поддомене sredda.ru.
Для этого достаточно добавить локальный домен в `/ets/hosts`, например:

    127.0.0.1 local.sredda.ru