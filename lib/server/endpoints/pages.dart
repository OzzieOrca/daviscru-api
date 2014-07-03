part of server;

@app.Group("$API_PREFIX/pages")
class Pages {
  @app.DefaultRoute()
  pages() => "Pages";
}
