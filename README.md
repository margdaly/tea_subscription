<h1 align="center">
 Tea Subscription API ☕
</h1>  

<p align="center"
    <a href="https://coveralls.io/github/badges/shields">
        <img src="https://img.shields.io/badge/coverage-100%25-lawngreen"
            alt="coverage"></a>
</p>

## Project Goals 
Create a REST API for a Tea Subscription Service
  - Easily consumed by a Frontend Developer
  - Restful routes 
  - Well-organized code, following OOP
  - Test Driven Development 

Exposes three endpoints to manage tea subscriptions
  - subscribe a customer to a tea subscription
  - cancel a customer's tea subscription
  - see all of a customer's subscriptions (active and cancelled)

## Built With
* Ruby v 2.7.4
* Rails v 5.2.8
* PostgreSQL

## Getting Started
1. Fork and Clone this repository locally
2. Install gem packages
`bundle install`
4. Set up the database
`rails db:{drop,create,migrate,seed}`
4. Make sure all tests are passing by running
`bundle exec rspec`
5. Start up your local server by running
`rails s`
6. You can make the sample request for each endpoint by running the examples in [Postman](https://app.getpostman.com/run-collection/26085409-1cb627ef-d500-4f6f-b849-9b655205c7ed?action=collection%2Ffork&collection-url=entityId%3D26085409-1cb627ef-d500-4f6f-b849-9b655205c7ed%26entityType%3Dcollection%26workspaceId%3Df402ed1d-531c-4451-ad21-b6367689bff9).
   
## Database Diagram
![Database Diagram](https://github.com/margdaly/tea_subscription/assets/121778028/21a2bcff-9bde-416d-ae8d-830b88f1580f)

## Endpoints
### POST `/api/v0/subscribe`
<details><summary> success </summary>
 
**create a new subscription**

**Parameters**  
| Name | Type | Description |
| ----------- | ----------- | ----------- | 
| **customer_id** | number | customer's id |
| **tea_id** | number | tea's id |
| **frequency** | 'weekly', 'monthly', or 'seasonal' | how often |

**Request**
  ```json
{
    "customer_id": 3,
    "tea_id": 6,
    "frequency": "monthly"
}
  ```
**Response**
status **200**
```
{
    "data": {
        "id": "13",
        "type": "subscription",
        "attributes": {
            "customer_id": 3,
            "tea_id": 6,
            "title": "Sleepytime Tea",
            "price": "$49.56",
            "status": "active",
            "frequency": "monthly"
        }
    }
}
```
</details>
<details><summary> error </summary>

**Invalid Tea ID**

**Request**
  ```json
{
    "customer_id": 3,
    "tea_id": 0,
    "frequency": "monthly"
}
  ```
**Response**
status **404**
```
{
    "errors": [
        {
            "status": "404",
            "title": "Record Invalid",
            "detail": "Validation failed: Tea must exist"
        }
    ]
}
```
</details>

### PATCH `/api/v0/cancel`
<details><summary> success </summary>
 
**cancel a subscription**

**Parameters**  
| Name | Type | Description |
| ----------- | ----------- | ----------- | 
| **customer_id** | number | customer's id |
| **tea_id** | number | tea's id |

**Request**
  ```json
{
    "customer_id": 1,
    "tea_id": 1
}
  ```
**Response**
status **200**
```
{
    "data": {
        "id": "1",
        "type": "subscription",
        "attributes": {
            "customer_id": 1,
            "tea_id": 1,
            "title": "Green Tea",
            "price": "$49.56",
            "status": "cancelled",
            "frequency": "monthly"
        }
    }
}
```
</details>
<details><summary> error </summary>

**Invalid Customer ID**

**Request**
  ```json
{
    "customer_id": 0,
    "tea_id": 1
}
  ```
**Response**
status **404**
```
{
    "errors": [
        {
            "status": "404",
            "title": "Record Invalid",
            "detail": "Couldn't find Subscription"
        }
    ]
}
```
</details>

### GET `/api/v0/customers/:id
<details><summary> success </summary>
 
**get customer details**

**Response**
status **200**
```
{
    "data": {
        "id": "2",
        "type": "customer",
        "attributes": {
            "first_name": "Harriet",
            "last_name": "Murphy",
            "email": "haphy@mail.com",
            "address": "24 Beachwood Ave",
            "subscriptions": [
                {
                    "id": 7,
                    "title": "Mint Tea",
                    "price": "$49.56",
                    "status": "active",
                    "frequency": "monthly",
                    "customer_id": 2,
                    "tea_id": 4,
                    "created_at": "2023-08-06T17:43:10.359Z",
                    "updated_at": "2023-08-06T17:43:10.359Z"
                },
                {
                    "id": 8,
                    "title": "Chamomile Tea",
                    "price": "$49.56",
                    "status": "active",
                    "frequency": "monthly",
                    "customer_id": 2,
                    "tea_id": 5,
                    "created_at": "2023-08-06T17:43:10.360Z",
                    "updated_at": "2023-08-06T17:43:10.360Z"
                },
                {
                    "id": 9,
                    "title": "Sleepytime Tea",
                    "price": "$214.76",
                    "status": "cancelled",
                    "frequency": "weekly",
                    "customer_id": 2,
                    "tea_id": 6,
                    "created_at": "2023-08-06T17:43:10.361Z",
                    "updated_at": "2023-08-06T17:43:10.361Z"
                }
            ]
        }
    }
}
```
</details>
<details><summary> error </summary>

**Invalid Customer ID**

**Response**
status **404**
```
{
    "errors": [
        {
            "status": "404",
            "title": "Record Invalid",
            "detail": "Couldn't find Customer with 'id'=0"
        }
    ]
}
```
</details>


