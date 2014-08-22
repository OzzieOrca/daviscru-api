library daviscru_router;

import 'package:angular/angular.dart';


void davisCruRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
      'tools': ngRoute(
          path: '/tools',
          mount: {
              'stats': ngRoute(
                  path: '/stats',
                  view: '/view/tools/stats.html'),
          }
      ),
      'admin': ngRoute(
          path: '/admin',
          view: '/view/admin/admin_template.html',
          mount: {
              'home': ngRoute(
                  defaultRoute: true,
                  path: '/home',
                  view: '/view/admin/home.html'
              ),
              'pages': ngRoute(
                  path: '/pages',
                  view: '/view/admin/pages.html'
              ),
          }
      ),
      'home': ngRoute(
          defaultRoute: true,
          enter: (RouteEnterEvent e) => router.go('page', {'pageUrl*': 'home'}, replace: true)
      ),
      'page': ngRoute(
          path: '/:pageUrl*',
          viewHtml: '<page></page>'
      ),
  });
}