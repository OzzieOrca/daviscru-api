library daviscru_router;

import 'package:angular/angular.dart';

void davisCruRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'tools': ngRoute(
          path: '/tools',
          mount: {
              'stats': ngRoute(
                  path: '/stats',
                  view: 'view/tools/stats.html'),
          }
      ),
      'page': ngRoute(
          defaultRoute: true,
          path: '/:pageUrl',
          view: 'view/page.html'
      ),
  });
}