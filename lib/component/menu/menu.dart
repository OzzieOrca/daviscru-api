library menu;

import 'package:angular/angular.dart';
part 'package:daviscru/models/menu_item.dart';
part 'package:daviscru/service/menu_repository.dart';

@Component(
    selector: 'main-menu',
    templateUrl: 'packages/daviscru/component/menu/menu.html',
    publishAs: 'menu',
    useShadowDom: false)
class MenuComponent {
  final MenuRepository _repo;
  List<MenuItem> menuItems;
  String loadStatus = "loading";

  MenuComponent(this._repo) {
    _repo.getMenuItems().then((returnedMenuItems){
      menuItems = returnedMenuItems;
      loadStatus = "success";
    }).catchError((_) => loadStatus = "error");
  }
}