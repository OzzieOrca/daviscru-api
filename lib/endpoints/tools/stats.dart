part of server;

@app.Group("$API_PREFIX/tools/stats")
@Secure("Admin")
class Stats {
  @app.DefaultRoute(methods: const [app.POST])
  stats(@app.Attr() MongoDb dbConn){
    return dbConn.collection("stats-categories").aggregate([
      {
        "\$sort": {"order": 1}
      }
    ]).then((categories){
      categories = categories["result"];
      return dbConn.collection("stats").aggregate([
          {
              "\$unwind": "\$stats"
          },
          {
              "\$group": {"_id": "\$stats.name", "sum": {"\$sum": "\$stats.value"}}
          },
          {
              "\$project": {"_id": false, "name": "\$_id", "sum": true}
          }
      ]).then((result){
        var stats = result["result"];
        return categories.map((category){
          return stats.firstWhere(
              (element) => element["name"] == category["name"],
              orElse: () => {"name": category["name"], "sum": 0}
          );
        }).toList();
      });
    });
  }

  @app.Route("/user", methods: const [app.POST])
  userStats(@app.Attr() MongoDb dbConn){

  }
}
