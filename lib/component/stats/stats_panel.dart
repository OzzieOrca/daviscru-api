library stats_panel;

import 'package:angular/angular.dart';

@Component(
    selector: 'stats-panel',
    templateUrl: 'packages/daviscru/component/stats/stats_panel.html',
    publishAs: 'statsPanel',
    useShadowDom: false)
class StatsPanelComponent {
  final Http _http;
  List<Stat> stats;
  String loadStatus = "loading";

  StatsPanelComponent(this._http) {
    stats = _loadData();
  }

  void save(){
    stats.forEach((stat) => stat.value += (stat.newRecordValue as int));
    clear();
  }

  void clear(){
    stats.forEach((stat) => stat.newRecordValue = 0);
  }

  List<Stat> _loadData() {
    _http.get('stats.json')
    .then((HttpResponse response) {
      stats = response.data.map((d) => new Stat.fromJson(d)).toList();
      loadStatus = "success";
    })
    .catchError((e) {
      loadStatus = "error";
    });
  }
}

class Stat {
  String name;
  int value;
  int newRecordValue;

  Stat(this.name, this.value, [this.newRecordValue = 0]);

  Stat.fromJson(Map<String, dynamic> json) : this(json['name'], json['value']);

  void increment(){
    newRecordValue++;
  }

  void decrement(){
    if(newRecordValue > 0){
      newRecordValue--;
    }
  }
}