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
    * print userData
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

  Scenario Outline: Validate error in the registration
    Given path 'users'
    And request
      """
    {
      "user": {
        "email": <email>,
        "password": <password>,
        "username": <username>
      }
    }
    """
    Then status 422
    And match response == <error>

    # aqui hay errores con la tabla examples
    Examples:
      | email                    | password     | username       | error                                              |
      | #(userEmail)             | "karate1234" | "karateRaul25" | {"errors":{"username":["has already been taken"]}} |
      | "karateRaul25@test.com"  | "karate1234" | #(username)    | {"errors":{"email":["has already been taken"]}}    |
      | #(userEmail)             | "karate1234" | ""             | {"errors":{"username":["can't be blank"]}}         |
      | ""                       | "karate1234" | #(username)    | {"errors":{"email":["can't be blank"]}}            |
      | #(userEmail)             | ""           | #(username)    | {"errors":{"password":["can't be blank"]}}         |


