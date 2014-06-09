library daviscru;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:angular/routing/module.dart';
import 'package:logging/logging.dart';

import 'package:daviscru/routing/daviscru_router.dart';
import 'package:daviscru/component/stats/stats_panel.dart';

@MirrorsUsed(targets: const ['stats_panel', 'daviscru_router'], override: '*')
import 'dart:mirrors';

class RoutingModule extends Module {
  RoutingModule() {
    bind(RouteInitializerFn, toValue: davisCruRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

class StatsModule extends Module {
  StatsModule() {
    bind(StatsPanelComponent);
  }
}

void main() {
  Logger.root..level = Level.FINEST
    ..onRecord.listen((LogRecord r) { print(r.message); });
  applicationFactory()
      .addModule(new RoutingModule())
      .addModule(new StatsModule())
      .run();
}