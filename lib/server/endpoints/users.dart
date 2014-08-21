part of server;

@app.Group("$API_PREFIX/users")
class Users {
  String accessToken;
  MongoDb dbConn;

  @app.DefaultRoute()
  users() => "Users";

  @app.Route("/authenticate/google/setup-api-request")
  googleAuthenticateSetupApiRequest(){
    Map response = new Map();
    if(app.request.session["csrf"] == null){
      app.request.session["csrf"] = generateCSRFToken(app.request.session.id, config["secret"]);
    }
    response["csrf"] = app.request.session["csrf"];
    response["client_id"] = config["oauth"]["google"]["client_id"];
    response["scope"] = config["oauth"]["google"]["scope"];
    return response;
  }

  @app.Route("/authenticate/google/verify", methods: const [app.POST])
  googleAuthenticateVerifyUser(@app.Attr() MongoDb dbConn, @app.Body(app.JSON) Map requestBody){
    this.dbConn = dbConn;
    if(requestBody["csrf"] == null || requestBody["csrf"] != app.request.session["csrf"]){
      return new shelf.Response(401, body: "CSRF Token Invalid");
    }
    accessToken = requestBody["access_token"];
    return http.get("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${accessToken}")
      .then((Response googleResponseJSON){
        Map googleResponse = JSON.decode(googleResponseJSON.body);
        if(googleResponse["error"] != null){
          return new shelf.Response(400, body: "${googleResponse["error"]}: ${googleResponse["error_description"]}");
        }
        if(googleResponse["user_id"] != requestBody["user_id"]){
          return new shelf.Response(401, body: "Token's user ID doesn't match given user ID");
        }
        if(googleResponse["email"] != requestBody["email"]){
          return new shelf.Response(401, body: "Token's email doesn't match given email");
        }
        if(googleResponse["audience"] != config["oauth"]["google"]["client_id"]){
          return new shelf.Response(401, body: "Token's client ID does not match this app's client ID");
        }
        return saveOrUpdateUser(googleResponse["user_id"], googleResponse["email"]).then((user){
          if(user == null){
            return {"verified": false};
          }
          user["verified"] = true;
          return user;
        });
      }).catchError((e) => print(e));
  }

  saveOrUpdateUser(String userId, String email){
    return dbConn.collection("users").findOne({'userId': userId}).then((user){
      if(user == null){
        return http.get("https://www.googleapis.com/oauth2/v1/userinfo?access_token=${accessToken}")
          .then((Response googleResponseJSON){
            Map googleResponse = JSON.decode(googleResponseJSON.body);
            dbConn.insert("users", {"role": "user", "userId": userId, "email": email, "name": googleResponse["name"], "picture": googleResponse["picture"]});
            return dbConn.collection("users").findOne({'userId': userId});
          }).catchError((e) => print(e));
      }else{
        return user;
      }
    });
  }
}
