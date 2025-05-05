Feature: Generate Token

  Background: Set base URL
    * url apiUrl

  Scenario: Obtain Authentication Token
    Given path 'users/login'
    And request {"user": {"email": "costa@gmail.com","password": "Costa123"}}
    When method POST
    Then status 200
    * def authToken = response.user.token
