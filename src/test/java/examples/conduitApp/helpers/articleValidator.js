function validateCreatedAtDates(articles, timeValidator) {
  for (var i = 0; i < articles.length; i++) {
    var date = articles[i].createdAt;
    if (!timeValidator.fn(date)) {
      karate.fail('Invalid createdAt date at index ' + i + ': ' + date);
    }
  }
}
