Feature: Generate Token

  Background: Set base URL
    * url apiUrl
    * def userData = read('classpath:examples/conduitApp/jsonData/dataLogin.json')


  Scenario: Obtain Authentication Token
    Given path 'users', 'login'
    And request userData
    When method POST
    Then status 200
    * def authToken = response.user.token
