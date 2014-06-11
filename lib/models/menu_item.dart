part of menu;

class MenuItem {
  String name;
  String url;
  List<MenuItem> subMenuItems;

  MenuItem(this.name, this.url, this.subMenuItems);
  MenuItem.category(this.name, this.subMenuItems);

  factory MenuItem.fromJson(Map<String, dynamic> json){
    List<MenuItem> subPages;
    if(json['subPages'] != null){
      subPages = json['subPages'].map((d) => new MenuItem.fromJson(d)).toList();
    }
    if(json['category'] == null){
      return new MenuItem(json['name'], json['url'], subPages);
    }else{
      return new MenuItem.category(json['category'], subPages);
    }
  }

  bool get isCategory => url == null && name != null;
}