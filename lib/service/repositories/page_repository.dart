part of page;

@Injectable()
class PageRepository {
  final Http _http;

  PageRepository(this._http);

  Future<List<Page>> getPage(){
    return _http.get('page.json')
    .then((HttpResponse response) {
      return new Page.fromJson(response.data);
    });
  }
}
