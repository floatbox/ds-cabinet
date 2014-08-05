# Client Cabinet

## Subsystems

В этом разделе описаны *внешние* системы, с которыми работает приложение:

* sns
* uas
* siebel
* interfax (spark)

### sns - Social Network System

Атавизм. Планировалась как полноценная система социальной сети пользователей портала.

В настоящее время используется для хранения какой-то информации о пользователе, щарегистрировавшемся на портале. Необходимо выпилить полностью.

#### using

Вся функциональность инкапсулирована в моделях Company и Person и в геме ds-sns

#### servers

  https://sns.dasreda.ru
  https://sns.sredda.ru:4443

#### configuration

  config/initializers/sns.rb

### uas - Unified Authentication System

Используется при регистрации и логине.

#### using

Вся функциональность инкапсулирована в моделях User и Uas::User

#### servers

  https://pim.sredda.ru
  https://pim.sredda.ru:4443
  https://ccdemopim.sredda.ru

#### configuration

Конфигурируется при настройке среды Rails. Почему там, а не в инициализаторах, непонятно.

  config/environments/test.rb
  config/environments/staging.rb
  config/environments/dsstaging.rb
  config/environments/production.rb
  config/environments/development.rb

### siebel - CRM - customer relationship management system

CRM система должна иметь данные о всех зарегистрированных пользователях с целью генерации лидов. Пользователи в CRM идентифицируются по номеру телефона (который хранится в атрибуте email таблицы системы CRM)

Если в процессе регистрации окажется, что пользователь с указанным номером телефона уже имеется в таблице CRM, в регистрации будет отказано. 

С этой системой приложение работает как при помощи подключения к базе данных через модель Account, так и при помощи API. Это было сделано для ускорения работы. Есть мнение, что надо переделать все взаимодействие с CRM с использованием API.

#### using

Вся функциональность инкапсулирована в моделях Account и Contact и в геме ds-siebel

#### servers

  Database 178.159.249.26  
  API https://sbldev.dasreda.ru
  API https://siebel.dasreda.ru:443
  API https://sbldev.dasreda.ru:8443

#### configuration

  config/initializers/siebel.rb
  config/database.yml

### Interfax (spark)

Предоставляет Soap API доступ к данным ФНС. Используем из этого пока только получение по ОГРН и ОГРНИП краткого отчета, из которого приложение забирает ИНН, назание компании и код региона, в котором зарегистрирована компания.

#### using

Вся функциональность по работе с системой инкапсулирована в гем ds-spark

#### servers

  http://sparkgatetest.interfax.ru
  http://webservicefarm.interfax.ru   

#### configuration

  config/initializers/spark.rb

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
      HostName ono.rrv.ru
      Port 2223
      User w3dev-ds-cabinet

Открываем "ssh тунель":

    локальный порт : ip оракла : удаленный порт : сервер
    ssh -L 1521:178.159.249.26:1521 sredda.ru

## Авторизация

Для работы авторизации требуется чтобы сайт находился на поддомене sredda.ru.
Для этого достаточно добавить локальный домен в `/ets/hosts`, например:

    127.0.0.1 local.sredda.ru
