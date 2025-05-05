@smokeTest
  Feature: Log In as User in Conduit

    Background: Set Base URL and the data to Log In
      Given url apiUrl
      * def userData = read('classpath:examples/conduitApp/jsonData/dataLogin.json')

    Scenario: Successfully log in as a user
      Given path 'users', 'login'
      And request userData
      When method POST
      Then status 200
      And response.user.email == userData.user.email
