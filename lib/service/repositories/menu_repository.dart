part of menu;

@Injectable()
class MenuRepository {
  final Http _http;

  MenuRepository(this._http);

  Future<List<MenuItem>> getMenuItems(){
    return _http.get('menu.json')
    .then((HttpResponse response) {
      return response.data.map((d) => new MenuItem.fromJson(d)).toList();
    });
  }
}
