import 'package:angular/angular.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "package:google_plus_v1_api/plus_v1_api_browser.dart" as plusclient;
import "dart:convert";

@Injectable()
class Authentication {
  final Http _http;
  GoogleOAuth2 _auth;
  String clientId;
  String scope;
  String csrf;

  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String role = "anonymous";
  bool buttonDataLoaded = false;
  bool signedIn = false;

  Authentication(this._http) {
    _http.get('api/v1/users/authenticate/google/setup-api-request')
      .then((HttpResponse response) {
        clientId = response.data["client_id"];
        scope = response.data["scope"];
        csrf = response.data["csrf"];
        buttonDataLoaded = true;
        _auth = new GoogleOAuth2(
            clientId,
            [scope],
            tokenLoaded: oauthReady);
      }).catchError((e) {
        print("Error loading Google+ Signin Button Data");
      });
  }

  void login(MouseEvent event){
    event.preventDefault(); // suppress default click action
    event.stopPropagation();
    _auth.login();
  }
  void logout(MouseEvent event){
    event.preventDefault(); // suppress default click action
    event.stopPropagation();
    signedIn = false;
    role = "anonymous";
    _auth.logout();
  }

  bool hasRole(String role) => role == this.role;

  oauthReady(Token token){
    //Verify Token
    Map dataToVerify = new Map();
    dataToVerify["csrf"] = csrf;
    dataToVerify["access_token"] = token.data;
    dataToVerify["user_id"] = token.userId;
    dataToVerify["email"] = token.email;
    _http.post('api/v1/users/authenticate/google/verify', JSON.encode(dataToVerify))
      .then((HttpResponse response) {
        if(response.data["verified"] == true){
          email = token.email;
          role = "user";
          var plus = new plusclient.Plus(_auth);
          plus.oauth_token = _auth.token.data;
          plus.people.get("me").then((person) {
            firstName = person.name.givenName;
            lastName = person.name.familyName;
            profilePicture = person.image.url;
            signedIn = true;
          }).catchError((_) => print("Error loading from Google+ API"));
        }
      }).catchError((e) => print(e));
  }
}
