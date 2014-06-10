library menu;

import 'package:angular/angular.dart';

@Component(
    selector: 'main-menu',
    templateUrl: 'packages/daviscru/component/menu/menu.html',
    publishAs: 'menu',
    useShadowDom: false)
class MenuComponent {
  final Http _http;
  List<MenuItem> menuItems;
  String loadStatus = "loading";

  MenuComponent(this._http) {
    //stats = _loadData();
  }

  /*List<Stat> _loadData() {
    _http.get('stats.json')
    .then((HttpResponse response) {
      stats = response.data.map((d) => new MenuItem.fromJson(d)).toList();
      loadStatus = "success";
    })
    .catchError((e) {
      loadStatus = "error";
    });
  }*/
}

class MenuItem {
  String name;
  String url;

  MenuItem(this.name, this.url);

  //Stat.fromJson(Map<String, dynamic> json) : this(json['name'], json['value']);

}