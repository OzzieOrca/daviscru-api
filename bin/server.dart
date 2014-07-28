library server;

import 'dart:math';
import 'dart:convert';

import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/metadata.dart';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_static/shelf_static.dart';
import 'package:dart_config/default_server.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

part "package:daviscru/server/utils.dart";
part "package:daviscru/server/endpoints/pages.dart";
part "package:daviscru/server/endpoints/users.dart";
part "package:daviscru/server/endpoints/tools/stats.dart";

const API_PREFIX = "/api/v1";
Map config;

void main() {
  loadConfig("config/parameters.yml").then(
    (Map loadedConfig) {
      config = loadedConfig;
      app.setShelfHandler(createStaticHandler("../web",
      defaultDocument: "index.html",
      serveFilesOutsidePath: true));

      var dbManager = new MongoDbManager(config["database"]["mongodb"]["uri"], poolSize: 5);
      app.addPlugin(getMapperPlugin(dbManager));

      app.setupConsoleLog();
      app.start(port: 80);
    },
    onError: (error) => print(error));
}