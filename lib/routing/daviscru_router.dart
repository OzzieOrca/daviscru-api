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
      'home': ngRoute(
          defaultRoute: true,
          enter: (RouteEnterEvent e) =>
            router.go('page', {'pageUrl': 'home'},
              replace: true
            )
      ),
      'page': ngRoute(
          path: '/:pageUrl',
          viewHtml: '<page></page>'
      ),
  });
}