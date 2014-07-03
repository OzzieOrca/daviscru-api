part of server;

@app.Group("$API_PREFIX/users")
class Users {

  @app.DefaultRoute()
  users() => "Users";

  @app.Route("/authenticate/google/setup-api-request")
  googleAuthenticateSetupApiRequest(){
    Map response = new Map();
    if(app.request.session["csrf"] == null){
      app.request.session["csrf"] = generateCSRFToken(app.request.session.id, config["parameters"]["secret"]);
    }
    response["csrf"] = app.request.session["csrf"];
    response["client_id"] = config["parameters"]["oauth"]["google"]["client_id"];
    response["scope"] = config["parameters"]["oauth"]["google"]["scope"];
    return response;
  }

  @app.Route("/authenticate/google/verify", methods: const [app.POST])
  googleAuthenticateVerifyUser(@app.Body(app.JSON) Map requestBody){
    if(requestBody["csrf"] == null || requestBody["csrf"] != app.request.session["csrf"]){
      return new shelf.Response(401, body: "CSRF Token Invalid");
    }
    return http.get("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${requestBody["access_token"]}")
      .then((Response responseJSON){
        Map response = JSON.decode(responseJSON.body);
        if(response["error"] != null){
          return new shelf.Response(400, body: "${response["error"]}: ${response["error_description"]}");
        }
        if(response["user_id"] != requestBody["user_id"]){
          return new shelf.Response(401, body: "Token's user ID doesn't match given user ID");
        }
        if(response["email"] != requestBody["email"]){
          return new shelf.Response(401, body: "Token's email doesn't match given email");
        }
        if(response["audience"] != config["parameters"]["oauth"]["google"]["client_id"]){
          return new shelf.Response(401, body: "Token's client ID does not match this app's client ID");
        }
        return {"verified": true};
      }).catchError((e) => print(e));
  }
}
