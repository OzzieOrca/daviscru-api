part of page;

class Widget {
  String widgetType;
  String headingText = "Heading";
  String subHeadingText = "Subheading";
  String bodyText = "Paragraph Text";
  Map<String, String> button = new Map<String, String>();
  String alignment = "right";
  bool hasDivider = false;
  List images = new List();
  List panelContent = new List<Map>();
  String videoUrl = "https://youtube.com/watch?v=2R_u1XPdJWA";

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

  void swapAlignment() {
    alignment == "left" ? alignment = "right" : alignment = "left";
  }
  void toggleDivider() {
    hasDivider = !hasDivider;
  }
}
