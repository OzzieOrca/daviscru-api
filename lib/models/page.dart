part of page;

class Page {
  String title;
  String url;
  Page parent;
  List<Widget> widgets = new List();

  Page(this.title, this.url, this.parent, [this.widgets]);

  Page.fromJson(Map<String, dynamic> json) : this(json['title'], json['url'], json['parent'], json['widgets'].map((d) => new Widget.fromJson(d)).toList());

  int _getWidgetIndex(Widget currentWidget) => widgets.indexOf(currentWidget);

  bool isFirstWidget(Widget currentWidget) => _getWidgetIndex(currentWidget) == 0;
  bool isLastWidget(Widget currentWidget) => _getWidgetIndex(currentWidget) == widgets.length - 1;

  void moveWidgetUp(Widget currentWidget){
    int index = _getWidgetIndex(currentWidget);
    if(index > 0){
      widgets[index] = widgets[index - 1];
      widgets[index - 1] = currentWidget;
    }
    widgets = widgets.toList(); //fixes issue with the ng-repeat not updating and displaying widgets in wrong places
  }

  void moveWidgetDown(Widget currentWidget){
    int index = _getWidgetIndex(currentWidget);
    if(index < widgets.length - 1){
      widgets[index] = widgets[index + 1];
      widgets[index + 1] = currentWidget;
    }
    widgets = widgets.toList(); //fixes issue with the ng-repeat not updating and displaying widgets in wrong places
  }

  void resetWidget(Widget currentWidget){
    int index = _getWidgetIndex(currentWidget);
    widgets[index] = new Widget(currentWidget.widgetType);
  }

  void deleteWidget(Widget currentWidget){
    widgets.remove(currentWidget);
  }

  void addWidget(MouseEvent event, String widgetType){
    event.preventDefault(); // suppress default click action
    event.stopPropagation();
    widgets.insert(0, new Widget(widgetType));
  }
}
