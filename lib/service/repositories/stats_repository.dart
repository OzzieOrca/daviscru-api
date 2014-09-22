part of stats_panel;

@Injectable()
class StatsRepository {
  final Http _http;

  StatsRepository(this._http);

  Future<List<Stat>> getStats(){
    return _http.get('/api/v1/tools/stats')
      .then((HttpResponse response) {
        return response.data.map((d) => new Stat.fromJson(d)).toList();
      });
  }
}
