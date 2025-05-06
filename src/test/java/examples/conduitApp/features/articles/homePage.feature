  @smokeTest
Feature: Validation of the articles page

  Background: Set Base URL
    * url apiUrl

  Scenario: Validate the tags
    Given path 'tags'
    When method GET
    Then status 200
    * def expectedTags = [ "Test", "GitHub", "Coding", "Git", "Enroll", "Bondar Academy", "Zoom", "qa career" ]
    And match response.tags != 'truck'
    And match response.tags == '#[10]'
    * print response.tags

  Scenario: Validate the articles structure
    Given path 'articles'
    And params { limit: 10, offset: 0 }
    When method GET
    Then status 200
    * def articles = response.articles
    And match articles == '#[10]'
    And match each response.articles ==
    """
    {
      slug: '#string',
      title: '#string',
      description: '#string',
      body: '#string',
      tagList: '#array',
      createdAt: '#string',
      updatedAt: '#string',
      favorited: '#boolean',
      favoritesCount: '#number',
      author: {
        username: '#string',
        bio: '##string',
        image: '#string',
        following: '#boolean'
      }
    }
    """







