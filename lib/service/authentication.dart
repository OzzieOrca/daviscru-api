import 'package:angular/angular.dart';
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "package:google_plus_v1_api/plus_v1_api_browser.dart" as plusclient;

@Injectable()
class Authentication {
  GoogleOAuth2 _auth;
  String firstName;
  String lastName;
  String email;
  String profilePicture;
  String role = "anonymous";
  bool loaded = false;

  Authentication() {
    _auth = new GoogleOAuth2(
        "331387729274.apps.googleusercontent.com", // Client ID
        ["openid", "email", plusclient.Plus.PLUS_ME_SCOPE],
        tokenLoaded: oauthReady);
  }

  void login() => _auth.login();
  void logout(){
    loaded = false;
    role = "anonymous";
    _auth.logout();
  }

  bool hasRole(String role) => role == this.role;

  oauthReady(Token token){
    email = token.email;
    role = "user";
    var plus = new plusclient.Plus(_auth);
    // set the API key
    plus.key = "hbxNZqr2g5RqKYgReasTFMCA";
    plus.oauth_token = _auth.token.data;
    plus.people.get("me").then((person) {
      firstName = person.name.givenName;
      lastName = person.name.familyName;
      profilePicture = person.image.url;
      loaded = true;
    }).catchError((_) => print("Error loading from Google+ API"));
  }
}
