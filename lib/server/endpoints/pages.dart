part of server;

@app.Group("$API_PREFIX/pages")
class PagesEndpoint {
  @app.DefaultRoute()
  pagesList(@app.Attr() MongoDb dbConn){
    return dbConn.collection("pages").find().toList();
  }

  @app.Route("/:url", matchSubPaths: true)
  pageData(@app.Attr() MongoDb dbConn, String url){
    return dbConn.collection("pages").findOne({'url': url}).then((page){
      if(page == null){
        return new app.ErrorResponse(404, {"error": "Page not found"});
      }else{
        return page;
      }
    });
  }

  @app.Route("/:url/:secondLevelUrl")
  pageDataWithSecondLevel(@app.Attr() MongoDb dbConn, String url, String secondLevelUrl){
    return dbConn.collection("pages").findOne({'url': url + '/' + secondLevelUrl}).then((page){
      if(page == null){
        return new app.ErrorResponse(404, {"error": "Page not found"});
      }else{
        return page;
      }
    });
  }

  @app.DefaultRoute(methods: const [app.POST])
  createPage(@app.Attr() MongoDb dbConn){
    dbConn.insert("pages", {"title": "New", "url": "new",});
    return "Created Page";
  }
}

