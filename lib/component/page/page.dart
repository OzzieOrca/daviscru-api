library page;

import 'package:angular/angular.dart';
//part 'package:daviscru/service/page_repository.dart';

part 'package:daviscru/models/page.dart';

@Component(
    selector: 'page',
    templateUrl: 'packages/daviscru/component/page/page.html',
    publishAs: 'page',
    useShadowDom: false)
class PageComponent {
  //final PageRepository _repo;
  //List<Widget> widgets;
  String loadStatus = "loading";
  String name = "Test Page";
  String url;

  PageComponent(/*this._repo, */RouteProvider routeProvider){
    url = routeProvider.parameters['pageUrl'];
    /*_repo.getStats().then((returnedStats){
      stats = returnedStats;
      loadStatus = "success";
    }).catchError((_) => loadStatus = "error");*/
  }
}