import 'dart:js';
import 'package:angular/angular.dart';

@Injectable()
class Global {
  String pageTitle;

  Global(Router router){
    router.onRouteStart.listen((RouteStartEvent event) {
      //Send route change as a pageview to Google Analytics
      context['ga'].apply(['send', 'pageview', event.uri]);
    });
  }
}
