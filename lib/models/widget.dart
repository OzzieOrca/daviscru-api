part of page;

class Widget {
  String widgetType;
  String headingText = "Heading";
  String subHeadingText = "Subheading";
  String bodyText = "Paragraph Text";
  String alignment = "left";
  bool hasDivider = false;
  String imageUrl = "http://placehold.it/500x500/FFD34E/000000";
  String imageAlt;
  String videoUrl = "https://youtube.com/watch?v=2R_u1XPdJWA";

  Widget(this.widgetType);

  Widget.fromJson(Map<String, dynamic> json){
    widgetType = json['widgetType'];
    headingText = json['headingText'];
    subHeadingText = json['subHeadingText'];
    bodyText = json['bodyText'];
    alignment = json['alignment'];
    hasDivider = json['hasDivider'];
    imageUrl = json['imageUrl'];
    imageAlt = json['imageAlt'];
    videoUrl = json['videoUrl'];
  }

  void swapAlignment() => alignment == "left" ? alignment = "right" : alignment = "left";
  void toggleDivider() => hasDivider = !hasDivider;
}
