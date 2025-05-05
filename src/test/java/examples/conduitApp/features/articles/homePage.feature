@smokeTest
Feature: Validation of the articles page

  Background: Set Base URL
    Given url apiUrl

  Scenario: Validate the tags
    Given path 'tags'
    When method GET
    Then status 200
    * def expectedTags = [ "Test", "GitHub", "Coding", "Git", "Enroll", "Bondar Academy", "Zoom", "qa career" ]
    # And match response.tags == expectedTags
    And match response.tags != 'truck'
    And response.tags == '#[8]'
    * print response.tags

  Scenario: Get the ten first articles and validate his structure
    Given path 'articles'
    And param limit = 10
    And param offset = 0
    When method GET
    Then status 200
    * def articles = response.articles
    And match articles == '#[10]'
    And match response.articlesCount == 48
  #aqui hay error con el json
#    * def articleSchema = """{
#      "slug": '#string',
#      "title": '#string',
#      "description": '#string',
#      "body": '#string',
#      "tagList": '#array',
#      "createdAt": '#string',
#      "updatedAt": '#string',
#      "favorited": '#boolean',
#      "favoritesCount": '#number',
#      "author": {
#        "username": '#string',
#        "bio": '#null:string',
#        "image": '#string',
#        "following": '#boolean'
#      }
#    }
#    """
#    And match response.articles == articleSchema
