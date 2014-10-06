part of server;

@app.Group("$API_PREFIX/auth")
class Auth {
  String accessToken;
  MongoDb get mongoDb => app.request.attributes.dbConn;

  @app.Route("/google/get-parameters")
  googleAuthenticateSetupApiRequest(){
    Map response = new Map();
    response["client_id"] = config["oauth"]["google"]["client_id"];
    response["scope"] = config["oauth"]["google"]["scope"];
    return response;
  }

  @app.Route("/google/login", methods: const [app.POST])
  @Login()
  googleLogin();
}