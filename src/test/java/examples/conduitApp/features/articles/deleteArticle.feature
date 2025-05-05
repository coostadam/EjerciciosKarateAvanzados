@smokeTest
Feature: Delete an article created

  Background: Set base URL
    Given url apiUrl + 'articles'

  Scenario: Remove article and validate it’s been purged
    When method GET
    Then status 200
    * def articles = response.articles
    * def articleToDelete = articles[0]

    Given path '/', articleToDelete.slug
    When method DELETE
    Then status 204

    When method GET
    Then status 200
    * def articlesAfterDelete = response.articles
    * def articleFound = articlesAfterDelete.find(article => article.slug == articleToDelete.slug)
    * assert !articleFound





