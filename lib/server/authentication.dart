part of server;

class Secure {
  final String role;
  const Secure(this.role);
}

class Login {
  const Login();
}

class Authentication{
  static MongoDb get mongoDb => app.request.attributes.dbConn;

  static Set computeRoles(String role){
    Set<String> roles = new Set<String>();
    switch(role){
      case 'admin':
        roles.add('Admin');
        continue editor;
    editor:
      case 'editor':
        roles.add('Editor');
        continue user;
    user:
      case 'user':
        roles.add('User');
        break;
    }
    return roles;
  }

  static void AuthenticationPlugin(app.Manager manager) {
    //Check for authorization level
    manager.addRouteWrapper(Secure, (metadata, pathSegments, injector, request, route) {
      return googleAuthVerifyUser(app.request.body["access_token"]).then((user) {
        if(user is shelf.Response){
          return user;
        }else{
          if(!user["verified"]){
            return new app.ErrorResponse(HttpStatus.UNAUTHORIZED, {"error": "NOT_AUTHORIZED"});
          }
          String role = (metadata as Secure).role;
          Set userRoles = computeRoles(user["role"]);
          if (!userRoles.contains(role)) {
            return new app.ErrorResponse(HttpStatus.UNAUTHORIZED, {"error": "NOT_AUTHORIZED"});
          }
        }
        return route(pathSegments, injector, request);
      });
    }, includeGroups: true);

    //Login
    manager.addResponseProcessor(Login, (metadata, handlerName, value, injector) {
      return googleAuthVerifyUser(app.request.body["access_token"], true);
    }, includeGroups: true);
  }

  static googleAuthVerifyUser(token, [bool update = false]){
    return http.get("https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=${token}")
    .then((googleResponseJSON){
      Map googleResponse = JSON.decode(googleResponseJSON.body);
      if(googleResponse["error"] != null){
        return new shelf.Response(400, body: "${googleResponse["error"]}: ${googleResponse["error_description"]}");
      }
      if(googleResponse["audience"] != config["oauth"]["google"]["client_id"]){
        return new shelf.Response(401, body: "Token's client ID does not match this app's client ID");
      }
      return saveOrUpdateUser(token, googleResponse["user_id"], update).then((user){
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

  static saveOrUpdateUser(String token, String userId, bool update){
    return mongoDb.collection("users").findOne({'userId': userId}).then((user){
      if(!update && user != null){
        return user;
      }else{
        return http.get("https://www.googleapis.com/oauth2/v1/userinfo?access_token=${token}")
        .then((googleResponseJSON){
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

//@app.Interceptor(r'/.*/tools/.*', parseRequestBody: true)
/*auth() {
  print("tools interceptor");
  var accessToken = app.request.body["access_token"];
  if(accessToken != null){
    print(accessToken);
    app.chain.next();
  }else{
    app.chain.interrupt(statusCode: HttpStatus.UNAUTHORIZED, responseValue: {"error": "NOT_AUTHENTICATED"});
  }
}*/