part of stats_panel;

@Injectable()
class StatsRepository {
  final Http _http;

  StatsRepository(this._http);

  Future<List<Stat>> getStats(){
    return _http.get('/stats.json')
      .then((HttpResponse response) {
        return response.data.map((d) => new Stat.fromJson(d)).toList();
      });
  }
}
