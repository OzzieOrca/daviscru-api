import 'package:angular/angular.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:convert";

@Injectable()
class Authentication {
  final Http _http;
  GoogleOAuth2 _auth;
  String clientId;
  String scope;
  String csrf;

  String name;
  String email;
  String profilePicture;
  String role = "anonymous";
  bool buttonDataLoaded = false;
  bool signedIn = false;

  Authentication(this._http) {
    _http.get('/api/v1/users/authenticate/google/setup-api-request')
      .then((HttpResponse response) {
        clientId = response.data["client_id"];
        scope = response.data["scope"];
        csrf = response.data["csrf"];
        _auth = new GoogleOAuth2(
            clientId,
            [scope],
            tokenLoaded: oauthReady,
            tokenNotLoaded: showLoginButton);
      }).catchError((e) {
        print("Error loading Google+ Signin Button Data");
      });
  }

  oauthReady(Token token){
    //Verify Token
    Map dataToVerify = new Map();
    dataToVerify["csrf"] = csrf;
    dataToVerify["access_token"] = token.data;
    dataToVerify["user_id"] = token.userId;
    dataToVerify["email"] = token.email;
    _http.post('/api/v1/users/authenticate/google/verify', JSON.encode(dataToVerify))
    .then((HttpResponse response) {
      Map serverResponse = response.data;
      if(serverResponse["verified"] == true){
        email = serverResponse["email"];
        role = serverResponse["role"];
        name = serverResponse["name"];
        profilePicture = serverResponse["picture"];
        buttonDataLoaded = true;
        signedIn = true;
      }
    }).catchError((e){
      buttonDataLoaded = true;
      print(e);
    });
  }
  
  void showLoginButton() => buttonDataLoaded = true;

  void login(){
    _auth.login();
    buttonDataLoaded = false;
  }
  void logout(){
    signedIn = false;
    role = "anonymous";
    _auth.logout();
  }

  bool hasRole(String role) => role == this.role;

  bool get canEdit => role == "admin";
}
