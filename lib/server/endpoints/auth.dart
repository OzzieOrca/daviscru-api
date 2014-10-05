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
  googleLogin(@app.Body(app.JSON) Map requestBody){
    return googleAuthVerifyUser(requestBody["access_token"], true);
  }

  googleAuthVerifyUser(token, [bool update = false]){
    this.accessToken = token;
    return http.get("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${accessToken}")
    .then((Response googleResponseJSON){
      Map googleResponse = JSON.decode(googleResponseJSON.body);
      if(googleResponse["error"] != null){
        return new shelf.Response(400, body: "${googleResponse["error"]}: ${googleResponse["error_description"]}");
      }
      if(googleResponse["audience"] != config["oauth"]["google"]["client_id"]){
        return new shelf.Response(401, body: "Token's client ID does not match this app's client ID");
      }
      return saveOrUpdateUser(googleResponse["user_id"], update).then((user){
        if(user == null){
          return {"verified": false};
        }
        Map filteredUserInfo = new Map();
        filteredUserInfo["verified"] = true;
        filteredUserInfo["name"] = user["name"];
        filteredUserInfo["picture"] = user["picture"];
        filteredUserInfo["role"] = user["role"];
        return filteredUserInfo;
      });
    }).catchError((e) => print(e));
  }

  saveOrUpdateUser(String userId, bool update){
    return mongoDb.collection("users").findOne({'userId': userId}).then((user){
      if(!update && user != null){
        return user;
      }else{
        return http.get("https://www.googleapis.com/oauth2/v1/userinfo?access_token=${accessToken}")
        .then((Response googleResponseJSON){
          Map googleResponse = JSON.decode(googleResponseJSON.body);
          if(user == null){
            mongoDb.insert("users", {"role": "user", "userId": userId, "email": googleResponse["email"], "name": googleResponse["name"], "picture": googleResponse["picture"]});
          }else{
            mongoDb.collection("users").update({'userId': userId}, {"\$set": {"email": googleResponse["email"], "name": googleResponse["name"], "picture": googleResponse["picture"]}});
          }
          return mongoDb.collection("users").findOne({'userId': userId});
        }).catchError((e) => print(e));
      }
    });
  }
}