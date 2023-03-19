// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

// ignore: camel_case_types
class platformViewRegistry {
  static registerViewFactory(
      String viewTypeId, html.Element Function(int viewId) viewFactory) {}
}
