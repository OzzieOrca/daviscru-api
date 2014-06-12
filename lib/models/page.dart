part of page;

class Page {
  String title;
  String url;
  Page parent;
  List<Widget> widgets;

  Page(this.title, this.url, this.parent, [this.widgets]);

  Page.fromJson(Map<String, dynamic> json) : this(json['title'], json['url'], json['parent'], json['widgets'].map((d) => new Widget.fromJson(d)).toList());
}
