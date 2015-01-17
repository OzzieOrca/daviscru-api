library auth;

import 'dart:html';
import 'package:angular/angular.dart';
import "package:googleapis_auth/auth_browser.dart";
import "dart:convert";

@Injectable()
class Authentication {
  final Http _http;
  BrowserOAuth2Flow flow;
  String clientId;
  String scope;
  String token;

  String name;
  String email;
  String profilePicture;
  String role = "anonymous";
  bool googleBtnVisible = false;
  bool signedIn = false;

  Authentication(this._http) {
    _http.get('/api/v1/auth/google/get-parameters')
      .then((HttpResponse response) {
        clientId = response.data["client_id"];
        scope = response.data["scope"];

        if(window.localStorage.containsKey('accessToken')){
          hideLoginButton();
          verifyToken(window.localStorage['accessToken']);
        }else{
          createFlow();
        }
      }).catchError((e) {
        print("Error loading Google+ Signin Button Data");
      });
  }

  createFlow(){
    createImplicitBrowserFlow(new ClientId(clientId, null), scope.split(' ')).then((BrowserOAuth2Flow flow) {
      this.flow = flow;
      showLoginButton();
    });
  }

  verifyToken(String token){
    Map dataToVerify = {"access_token": token};
    _http.post('/api/v1/auth/google/login', JSON.encode(dataToVerify))
    .then((HttpResponse response) {
      Map<String, dynamic> serverResponse = response.data;
      if(serverResponse != null && serverResponse["verified"] == true){
        this.token = token;
        email = serverResponse["email"];
        role = serverResponse["role"];
        name = serverResponse["name"];
        profilePicture = serverResponse["picture"];
        signedIn = true;
        showLoginButton();
        window.localStorage['accessToken'] = token;
      }else{
        throw new Exception("Access token not verified");
      }
    }).catchError((e){
      createFlow();
      window.localStorage.remove('accessToken');
      print(e);
    });
  }



  void login(){
    if(flow != null) {
      hideLoginButton();
      flow.obtainAccessCredentialsViaUserConsent()
      .then((AccessCredentials credentials) {
        verifyToken(credentials.accessToken.data);
        flow.close();
      }).catchError((e) => print(e));
    }
  }

  void logout(){
    signedIn = false;
    role = "anonymous";
    token = null;
    window.localStorage.remove('accessToken');
    createFlow();
  }

  void showLoginButton(){
    googleBtnVisible = true;
  }
  void hideLoginButton(){
    googleBtnVisible = false;
  }

  bool hasRole(String role) => role == this.role;

  bool get canEdit => role == "admin";
  bool get isAdmin => role == "admin";
}
