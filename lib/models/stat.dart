part of stats_panel;

class Stat {
  String name;
  int value;
  int newRecordValue;

  Stat(this.name, this.value, [this.newRecordValue = 0]);

  Stat.fromJson(Map<String, dynamic> json) : this(json['name'], json['sum']);

  void increment(){
    newRecordValue++;
  }

  void decrement(){
    if(newRecordValue > 0){
      newRecordValue--;
    }
  }
}