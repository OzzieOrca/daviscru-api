import 'package:redstone/server.dart' as app;
import 'package:shelf_static/shelf_static.dart';

@app.Group("/api/v1")
class API {
  @app.Route("/pages")
  pages() => "Pages";

  @app.Route("/users")
  users() => "Users";

  @app.Route("/tools/stats")
  stats() => "Stats";
}

void main() {
  app.setShelfHandler(createStaticHandler("../web",
      defaultDocument: "index.html",
      serveFilesOutsidePath: true));

  app.setupConsoleLog();
  app.start(port: 80);
}