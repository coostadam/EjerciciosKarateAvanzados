@smokeTest
Feature: Register Users in Conduit

  Background: Set Base URL and the data to register
    Given url apiUrl
    * def userData = read('classpath:examples/conduitApp/jsonData/dataRegister.json')
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * def userEmail = DataGenerator.getRandomEmail()
    * def username = DataGenerator.getRandomUsername()
    * set userData.user.username = username
    * set userData.user.email = userEmail
    * set userData.user.password = 'karate1234'

  Scenario: Register a new user
    Given path 'users'
    And request userData
    When method POST
    Then status 201
    And match response ==
    """{
      "user": {
        "id": '#number',
        "email": #(userEmail),
        "username": #(username),
        "bio": null,
        "image": '#string',
        "token": '#string'
      }
    }
    """

  Scenario Outline: User Registration in Conduit
    Given path 'users'
    And request
    """
    {
      "user": {
        "email": "<email>",
        "password": "<password>",
        "username": "<username>"
      }
    }
    """
    When method Post
    Then status 422
    And match response == <error>

    Examples:
      | email                 | password   | username     | error                                              |
      | #(userEmail)          | Karate1234 | KarateRaul25 | {"errors":{"username":["has already been taken"]}} |
      | karateRaul25@test.com | Karate1234 | #(username)  | {"errors":{"email":["has already been taken"]}}    |
      | #(userEmail)          | Karate1234 |              | {"errors":{"username":["can't be blank"]}}         |
      |                       | Karate1234 | #(username)  | { "errors": { "email": ["can't be blank"] } }      |
      | #(userEmail)          |            | #(username)  | { "errors": { "password": ["can't be blank"] } }   |

    #queda como duda que en la request no se le asigna el valor de userEmail, username y password

