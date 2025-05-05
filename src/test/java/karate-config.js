function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit-api.bondaracademy.com/api/',
  }

  if (env == 'dev') {
    config.userEmail = 'costa@gmail.com'
    config.userPassword = '123456789'
  } else if (env == 'qa') {
    config.userEmail = 'costa@gmail.com'
    config.userPassword = '123456789'
  }

  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  var accessToken = karate.callSingle('classpath:examples/conduitApp/helpers/createToken.feature', config).authToken;
  karate.configure('headers', {Authorization: 'Token ' + accessToken});

  return config;
}