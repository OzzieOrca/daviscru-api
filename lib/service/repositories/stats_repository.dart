part of stats_panel;

@Injectable()
class StatsRepository {
  final Http _http;
  final Authentication auth;

  StatsRepository(this._http, this.auth);

  Future<List<Stat>> getStats(){
    Map postData = {"access_token": auth.token};
    return _http.post('/api/v1/tools/stats', JSON.encode(postData))
      .then((HttpResponse response) {
        return response.data.map((d) => new Stat.fromJson(d)).toList();
      });
  }
}
