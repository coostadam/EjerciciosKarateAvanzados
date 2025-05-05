@smokeTest
Feature: Manage articles.

  Background: Set base URL, initialize data generator, and get access token
    Given url apiUrl + 'articles'
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')

  Scenario: Get all articles, create a new article, and check its creation
    When method GET
    Then status 200
    * print response.articles

    * def newArticle = DataGenerator.getRandomArticleValues()

    And request { article: #(newArticle) }
    When method POST
    Then status 201
    And response.article.title == newArticle.title
    * def createdArticle = response.article
    * def slugId = createdArticle.slug

    When method GET
    Then status 200
    * print response.articles

  Scenario: Update the article generated
    When method GET
    Then status 200
    * def articles = response.articles
    * def articleToUpdate = articles[0]
    * def updatedArticle = DataGenerator.getRandomArticleValues()

    Given path '/', articleToUpdate.slug
    And request { article: #(updatedArticle) }
    When method PUT
    Then status 200
    And response.article.title == updatedArticle.title


