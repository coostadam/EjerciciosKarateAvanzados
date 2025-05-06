@smokeTest
Feature: Manage articles.

  Background: Set base URL, initialize data generator, and get access token
    * url apiUrl + '/articles'
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * def articleRequest = read('classpath:examples/conduitApp/jsonData/newArticleRequest.json')
    * set articleRequest.article.title = DataGenerator.getRandomArticleValues().title
    * set articleRequest.article.description = DataGenerator.getRandomArticleValues().description
    * set articleRequest.article.body = DataGenerator.getRandomArticleValues().body

  Scenario: Create a new article
    When method GET
    Then status 200
    * def articlesCount = response.articlesCount

    And request articleRequest
    When method POST
    Then status 201
    And match response.article.title == articleRequest.article.title

    When method GET
    Then status 200
    And match response.articlesCount == articlesCount + 1

  Scenario: Create new article and delete the article
    And request articleRequest
    When method POST
    Then status 201
    * def slugID = response.article.slug

    And params { limit: 10, offset: 0 }
    When method GET
    Then status 200

    When method GET
    Then status 200
    And match response.articles[0].slug == slugID

    Given path slugID
    When method DELETE
    Then status 204

    And params { limit: 10, offset: 0 }
    When method GET
    Then status 200
    And match response.articles[0].slug != slugID



