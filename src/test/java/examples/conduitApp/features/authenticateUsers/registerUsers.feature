@smokeTest
  @ignore
Feature: Register Users in Conduit

  Background: Set Base URL and the data to register
    * url apiUrl
    * def userData = read('classpath:examples/conduitApp/jsonData/dataRegister.json')
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * def userEmail = DataGenerator.getRandomEmail()
    * def username = DataGenerator.getRandomUsername()
    * def password = DataGenerator.getRandomPassword()
    * set userData.user.username = username
    * set userData.user.email = userEmail
    * set userData.user.password = 'karate1234'

  @ignore
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
        "bio": '##string',
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
      | email                 | password    | username     | error                                              |
      | #(userEmail)          | #(password) | KarateRaul25 | {"errors":{"username":["has already been taken"]}} |
      | karateRaul25@test.com | #(password) | #(username)  | {"errors":{"email":["has already been taken"]}}    |
      | #(userEmail)          | #(password) |              | {"errors":{"username":["can't be blank"]}}         |
      |                       | #(password) | #(username)  | {"errors":{"email":["can't be blank"]}}            |
      | #(userEmail)          |             | #(username)  | {"errors":{"password":["can't be blank"]}}         |