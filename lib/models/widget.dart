part of page;

class Widget {
  String widgetType;
  String headingText = "Heading";
  String subHeadingText = "Subheading";
  String bodyText = "Paragraph Text";
  Map button = new Map<String, String>();
  String alignment = "right";
  bool hasDivider = false;
  List images = new List();
  List panelContent = new List<Map>();
  String videoUrl = "https://youtube.com/watch?v=2R_u1XPdJWA";
  int _order; // Location in widgets array

  Widget(this.widgetType);

  Widget.fromJson(Map<String, dynamic> json){
    widgetType = json['widgetType'];
    headingText = json['headingText'];
    subHeadingText = json['subHeadingText'];
    bodyText = json['bodyText'];
    button = json['button'];
    alignment = json['alignment'];
    if(alignment == null || alignment.isEmpty){
      alignment = "right";
    }
    hasDivider = json['hasDivider'];
    images = json['images'];
    panelContent = json['panelContent'];
    videoUrl = json['videoUrl'];
  }

  void swapAlignment() => alignment == "left" ? alignment = "right" : alignment = "left";
  void toggleDivider() => hasDivider = !hasDivider;

  //TODO: Fix: Hack to allow storing of order from outer ng-repeat over widgets
  int get order => _order;
  void set order(order) => _order = order;
  void setOrder(int newOrder){
    _order = newOrder;
  }
}
