@smokeTest
  @ignore
Feature: Manage articles.

  Background: Set base URL, initialize data generator, and get access token
    Given url apiUrl, '/articles'
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * def articleRequest = read('classpath:examples/conduitApp/jsonData/newArticleRequest.json')
    * set articleRequest.article.title = DataGenerator.getRandomArticleValues().title
    * set articleRequest.article.description = DataGenerator.getRandomArticleValues().description
    * set articleRequest.article.body = DataGenerator.getRandomArticleValues().body

  Scenario: Create a new article
    And request articleRequest
    When method POST
    Then status 201
    And response.article.title == articleRequest.article.title

  Scenario: Create new article and delete the article
    And request articleRequest
    When method POST
    Then status 201
    * def slugID = response.article.slug

    And param limit = 10
    And param offset = 0
    When method GET
    Then status 200
    And response.articles[0].slug == slugID
    * print response.articles

    Given path slugID
    When method DELETE
    Then status 204

    And param limit = 10
    And param offset = 0
    When method GET
    Then status 200
    And response.articles[0].slug != slugID



