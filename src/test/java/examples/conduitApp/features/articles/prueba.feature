Feature: Tratar artículos.

  Background:
    Given url apiUrl
    * def DataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')

  Scenario: Obtener todos los artículos disponibles
    When method GET
    Then status 200
    * print response.articles

  @wip
  Scenario: Publicar un artículo
    Given path 'articles'
#    * def newArticle = DataGenerator.getRandomArticleValues()
#    And request { article: #(newArticle) }
    And request read('classpath:examples/conduitApp/jsonData/newArticleRequest.json')
    When method POST
    Then status 201
    * print response.article

