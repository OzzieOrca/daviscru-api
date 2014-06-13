part of page;

class Page {
  String title;
  String url;
  Page parent;
  List<Widget> widgets;

  Page(this.title, this.url, this.parent, [this.widgets]);

  Page.fromJson(Map<String, dynamic> json) : this(json['title'], json['url'], json['parent'], json['widgets'].map((d) => new Widget.fromJson(d)).toList());

  int _findWidgetIndex(Widget currentWidget){
    return widgets.indexOf(currentWidget);
  }

  void moveWidgetUp(Widget currentWidget){
    int index = _findWidgetIndex(currentWidget);
    if(index > 0 && index < widgets.length){
      Widget temp = widgets[index];
      widgets[index] = widgets[index - 1];
      widgets[index - 1] = temp;
    }
  }

  void moveWidgetDown(Widget currentWidget){
    int index = _findWidgetIndex(currentWidget);
    if(index < widgets.length - 1){
      Widget temp = widgets[index];
      widgets[index] = widgets[index + 1];
      widgets[index + 1] = temp;
    }
  }

  void resetWidget(Widget currentWidget){
    widgets[index] = new Widget(currentWidget.widgetType);
  }

  void deleteWidget(Widget currentWidget){
    widgets.remove(currentWidget);
  }
}
