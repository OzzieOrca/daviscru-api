part of server;

@app.Group("$API_PREFIX/tools/stats")
class Stats {
  @app.DefaultRoute()
  stats() => "Stats";
}
