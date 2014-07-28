library page;

import 'package:angular/angular.dart';
part 'package:daviscru/service/repositories/page_repository.dart';

part 'package:daviscru/models/page.dart';
part 'package:daviscru/models/widget.dart';

@Component(
    selector: 'page',
    templateUrl: 'packages/daviscru/component/page/page.html',
    publishAs: 'pgComp',
    useShadowDom: false)
class PageComponent {
  final PageRepository _repo;
  Page page;
  String loadStatus = "loading";
  String url;

  PageComponent(this._repo, RouteProvider routeProvider){
    url = routeProvider.parameters['pageUrl*'];
    _repo.getPage(url).then((returnedPage){
      page = returnedPage;
      loadStatus = "success";
    }).catchError((_) => loadStatus = "error");
  }
}