library title;

import 'package:angular/angular.dart';
import 'package:daviscru/service/global.dart';

@Component(
    selector: 'title',
    template: 'Cru at UC Davis | {{titleComp.global.pageTitle}}',
    publishAs: 'titleComp',
    useShadowDom: false)
class TitleComponent {
  final Global global;

  TitleComponent(this.global);
}