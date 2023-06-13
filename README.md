# Good Night

## Introduction
Good Night is a sleep tracker. Created for interview purpose.

## Features
* Create user.
* Clock in and clock out sleep.
* Follow and unfollow other users.

## Installation Guide
* Install [Rails](https://rubyonrails.org/)
* Clone this repository [here](https://github.com/herdibintang/good-night.git).
* Run `bin/rails db:migrate` to run all migrations.

## Usage
* Run `bin/rails server` to start the application.
* Connect to the API using Postman on port 3000.

## API Endpoints
| HTTP Verbs | Endpoints | Action |
| --- | --- | --- |
| POST | /users | To create a user |
| GET | /users | To get list of all users |
| POST | /users/:userId/clock-in | To clock in sleep for a user |
| POST | /users/:userId/clock-out | To clock out sleep for a user |
| GET | /users/:userId/sleeps | To list all user's sleeps |
| POST | /users/:userId/follow | To follow a user |
| POST | /users/:userId/unfollow | To unfollow a user |
| GET | /users/:userId/followings | To get all list of users that a user follow |
| GET | /users/:userId/followings/sleeps | To get all list of sleeps from a user's followings |
| GET | /sleeps | To list all sleeps |

### Create User
```POST /users```
Example request:
```json
{
    "name": "Alice"
}
```
Example response:
```json
{
    "message": "Create user success",
    "data": {
        "id": 1,
        "name": "Alice"
    }
}
```

### User List
```GET /users```
Example response:
```json
{
    "data": [
        {
            "id": 1,
            "name": "Alice"
        }
    ]
}
```

### User Clock In
```POST /users/:userId/clock-in```
Example request:
```json
{
    "datetime": "2023-06-08 20:00:00"
}
```
Example response:
```json
{
    "message": "Clock in success"
}
```

### User Clock Out
```POST /users/:userId/clock-out```
Example request:
```json
{
    "datetime": "2023-06-08 20:00:00"
}
```
Example response:
```json
{
    "message": "Clock out success"
}
```

### User Sleep List
```GET /users/:userId/sleeps```
Example response:
```json
{
    "data": [
        {
            "clock_in": "2023-06-08 20:00:00",
            "clock_out": "2023-06-09 21:00:00",
            "duration_in_second": 86400
        }
    ]
}
```

### User Follow
```POST /users/:userId/follow```
Example request:
```json
{
    "user_id": 2
}
```
Example response:
```json
{
    "message": "Follow success"
}
```

### User Unfollow
```POST /users/:userId/unfollow```
Example request:
```json
{
    "user_id": 2
}
```
Example response:
```json
{
    "message": "Unfollow success"
}
```

### User Following List
```GET /users/:userId/followings```
Example response:
```json
{
    "data": [
        {
            "id": 2,
            "name": "Bob"
        }
    ]
}
```

### User Following Sleep List
```GET /users/:userId/followings/sleeps```
Example response:
```json
{
    "data": [
        {
            "clock_in": "2023-06-08 20:00:00",
            "clock_out": "2023-06-09 21:00:00",
            "duration_in_second": 86400,
            "user": {
                "name": "Bob"
            }
        }
    ]
}
```

### Sleep List
```GET /sleeps```
Example response:
```json
{
    "data": [
        {
            "clock_in": "2023-06-08 20:00:00",
            "clock_out": "2023-06-09 21:00:00",
            "duration_in_second": 86400,
            "user": {
                "name": "Bob"
            }
        }
    ]
}
```