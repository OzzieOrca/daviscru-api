library page;

import 'dart:html';
import 'package:angular/angular.dart';
import 'package:daviscru/service/authentication.dart';
import 'package:daviscru/service/global.dart';
part 'package:daviscru/service/repositories/page_repository.dart';

part 'package:daviscru/models/page.dart';
part 'package:daviscru/models/widget.dart';

@Component(
    selector: 'page',
    templateUrl: '/packages/daviscru/component/page/page.html',
    module: PageComponent.module,
    useShadowDom: false)
class PageComponent {
  static void module(DirectiveBinder binder) =>
      binder.bind(NodeValidator, toFactory: () {
        final validator = new NodeValidatorBuilder()
          ..allowImages()
          ..allowElement('IFRAME', attributes: ['src', 'width', 'height', 'marginwidth', 'marginheight', 'frameborder'])
          ..allowElement('A', attributes: ['href','onclick','target'])
          ..allowElement('BUTTON', attributes: ['btn-radio', 'btn-checkbox', 'btn-checkbox-false', 'btn-checkbox-true', 'popover', 'popover-animation', 'popover-placement', 'popover-title', 'popover-trigger', 'tooltip'])
          ..allowElement('DIV', attributes: ['class', 'collapse', 'style'])
          ..allowElement('FORM', attributes: ['class','role'])
          ..allowElement('I', attributes: ['class','style'])
          ..allowElement('IMG', attributes: ['class','style','src'])
          ..allowElement('H1', attributes: ['class','style'])
          ..allowElement('H2', attributes: ['class','style'])
          ..allowElement('H3', attributes: ['class','style'])
          ..allowElement('P', attributes: ['class','style'])
          ..allowElement('TABLE', attributes: ['class','style'])
          ..allowElement('TBODY', attributes: ['class','style'])
          ..allowElement('UL', attributes: ['class','style'])
          ..allowElement('LI', attributes: ['class','style'] )
          ..allowElement('TR', attributes: ['class','style'])
          ..allowElement('TD', attributes: ['class','style','align','colspan'])
          ..allowElement('BR', attributes: ['class','style'])
          ..allowElement('B', attributes: ['class','style']);

        return validator;
      }, visibility: Visibility.CHILDREN);

  final PageRepository _repo;
  final Authentication auth;
  final Global global;
  Page page;
  String loadStatus = "loading";
  String url;

  PageComponent(this._repo, this.auth, this.global, RouteProvider routeProvider){
    String rawUrl = routeProvider.parameters['pageUrl*'];
    if(rawUrl.endsWith('/')){
      url = rawUrl.substring(0, rawUrl.length - 1);
    }else{
      url = rawUrl;
    }

    _repo.getPage(url).then((returnedPage){
      page = returnedPage;
      global.pageTitle = page.title;
      loadStatus = "success";
    }).catchError((_) => loadStatus = "error");
  }
}