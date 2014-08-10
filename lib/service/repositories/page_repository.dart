part of page;

@Injectable()
class PageRepository {
  final Http _http;

  PageRepository(this._http);

  Future<List<Page>> getPage(String url){
    return _http.get('/api/v1/pages/$url')
      .then(
        (HttpResponse response) {
          if(response.data.isEmpty){
            return null;
          };
          return new Page.fromJson(response.data);
        },
        onError: (HttpResponse response) {
          throw(response);
        }
      );
  }
}
