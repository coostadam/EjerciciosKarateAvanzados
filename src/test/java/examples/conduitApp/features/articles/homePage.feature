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

  Scenario: Validate the articles structure
    Given path 'articles'
    And params { limit: 10, offset: 0 }
    When method GET
    Then status 200
    * def articles = response.articles
    And match articles == '#[10]'
    * def validateArticles =
    """
    function(articles) {
      for (var i = 0; i < articles.length; i++) {
        var fecha = articles[i].createdAt;
        var esValida = TimeValidator.fn(fecha);
        karate.log('valid:', esValida);
        if(!esValida) {
          karate.fail('The date is not valid');
        }
      }
    }
    """
    * eval validateArticles(articles)
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







