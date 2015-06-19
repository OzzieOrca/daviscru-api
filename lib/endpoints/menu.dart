part of server;

@app.Group("$API_PREFIX/menu")
class MenuEndpoint {
  @app.DefaultRoute()
  menuItems(@app.Attr() MongoDb dbConn){
    return dbConn.collection("menu").findOne();
  }
}

