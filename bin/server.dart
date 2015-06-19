library server;

import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:redstone/server.dart' as app;
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/metadata.dart';

import 'package:dart_config/default_server.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

part "package:daviscru_api/authentication.dart";
part "package:daviscru_api/endpoints/pages.dart";
part "package:daviscru_api/endpoints/menu.dart";
part "package:daviscru_api/endpoints/users.dart";
part "package:daviscru_api/endpoints/auth.dart";
part "package:daviscru_api/endpoints/tools/stats.dart";

const API_PREFIX = "/api/v1";
Map config;

void main() {
  loadConfig("config/private/parameters.yaml").then(
    (Map loadedConfig) {
      config = loadedConfig;

      var dbManager = new MongoDbManager(config["database"]["mongodb"]["uri"], poolSize: 5);
      app.addPlugin(getMapperPlugin(dbManager));
      app.addPlugin(Authentication.AuthenticationPlugin);

      app.setupConsoleLog();
      app.start();
    },
    onError: (error) => print(error)
  );
}