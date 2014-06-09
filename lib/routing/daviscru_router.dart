library daviscru_router;

import 'package:angular/angular.dart';

void davisCruRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'home': ngRoute(
          defaultRoute: true,
          path: '/home',
          view: 'view/home.html'),
      'test': ngRoute(
          path: '/test',
          view: 'view/test.html'),
      'tools': ngRoute(
          path: '/tools',
          mount: {
              'stats': ngRoute(
                  path: '/stats',
                  view: 'view/tools/stats.html'),
          })
  });
}