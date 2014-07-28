part of server;

@app.Group("$API_PREFIX/pages")
class PagesEndpoint {
  @app.DefaultRoute()
  pagesList(@app.Attr() MongoDb dbConn){
    return dbConn.collection("pages").find().toList();
  }

  @app.Route("/:url")
  pageData(@app.Attr() MongoDb dbConn, String url){
    return dbConn.collection("pages").findOne({'url': url});
  }

  @app.DefaultRoute(methods: const [app.POST])
  createPage(@app.Attr() MongoDb dbConn){
    dbConn.insert("pages", {"title": "New", "url": "new",});
    return "Created Page";
  }
}

