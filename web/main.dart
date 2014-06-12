library daviscru;

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:angular/routing/module.dart';
import 'package:logging/logging.dart';

import 'package:daviscru/routing/daviscru_router.dart';
import 'package:daviscru/component/menu/menu.dart';
import 'package:daviscru/component/page/page.dart';
import 'package:daviscru/component/stats/stats_panel.dart';

@MirrorsUsed(targets: const ['daviscru_router', 'stats_panel', 'menu'], override: '*')
import 'dart:mirrors';

class RoutingModule extends Module {
  RoutingModule() {
    bind(RouteInitializerFn, toValue: davisCruRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

class MenuModule extends Module {
  MenuModule() {
    bind(MenuComponent);
    bind(MenuRepository);
  }
}

class PageModule extends Module {
  PageModule() {
    bind(PageComponent);
    bind(PageRepository);
  }
}

class StatsModule extends Module {
  StatsModule() {
    bind(StatsPanelComponent);
    bind(StatsRepository);
  }
}

void main() {
  /*Logger.root..level = Level.FINEST
    ..onRecord.listen((LogRecord r) { print(r.message); });*/
  applicationFactory()
      .addModule(new RoutingModule())
      .addModule(new MenuModule())
      .addModule(new PageModule())
      .addModule(new StatsModule())
      .run();
}