@smokeTest
Feature: Validation of the articles page

  Background: Set Base URL
    * url apiUrl
    * def TimeValidator = karate.read('classpath:examples/conduitApp/helpers/timeValidator.js')

  Scenario: Validate the tags
    Given path 'tags'
    When method GET
    Then status 200
    * def expectedTags = [ "Test", "GitHub", "Coding", "Git", "Enroll", "Bondar Academy", "Zoom", "qa career" ]
    And match response.tags != 'truck'
    And match response.tags == '#[10]'
    * print response.tags

  Scenario: Validate the structure and createdAt format of the first 10 articles
    Given path 'articles'
    And params { limit: 10, offset: 0 }
    When method GET
    Then status 200
    * def articles = response.articles
    And match articles == '#[10]'
    # Validar formato de fechas con función externa
    * def validateArticleDates =
  """
    function(articles) {
      for (var i = 0; i < articles.length; i++) {
        var date = articles[i].createdAt;
        if (!TimeValidator.fn(date)) {
          karate.fail('Invalid createdAt date at index ' + i + ': ' + date);
        }
      }
    }
    """
    * eval validateArticlesDates(articles)
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







