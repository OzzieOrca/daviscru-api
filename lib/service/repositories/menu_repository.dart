part of menu;

@Injectable()
class MenuRepository {
  final Http _http;

  MenuRepository(this._http);

  Future<List<MenuItem>> getMenuItems(){
    return _http.get('api/v1/menu')
    .then((HttpResponse response) {
      return response.data['items'].map((d) => new MenuItem.fromJson(d)).toList();
    });
  }
}
