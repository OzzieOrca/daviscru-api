part of server;

@app.Group("$API_PREFIX/users")
class Users {

  @app.DefaultRoute()
  users() => "Users";
}
