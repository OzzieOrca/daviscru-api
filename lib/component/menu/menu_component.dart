library menu;

import 'package:angular/angular.dart';
import 'package:daviscru/service/authentication.dart';
//import 'package:daviscru/component/page/page_component.dart';

part 'package:daviscru/models/menu_item.dart';
part 'package:daviscru/service/repositories/menu_repository.dart';

@Component(
    selector: 'main-menu',
    templateUrl: 'packages/daviscru/component/menu/menu.html',
    publishAs: 'menu',
    useShadowDom: false)
class MenuComponent {
  final MenuRepository _repo;
  final Authentication auth;
  //final PageComponent _pageComponent;
  List<MenuItem> menuItems;
  String loadStatus = "loading";

  MenuComponent(this._repo, this.auth/*, this._pageComponent*/) {
    //print("Current route: ${_pageComponent.url}");
    _repo.getMenuItems().then((returnedMenuItems){
      menuItems = returnedMenuItems;
      loadStatus = "success";
    }).catchError((_) => loadStatus = "error");
  }
  bool isActive(String menuItemUrl){
    /*print("Current route: ${routeProvider.parameters['pageUrl']} menuItemUrl: $menuItemUrl");
    return routeProvider.parameters['pageUrl'] == menuItemUrl;*/
  }
}