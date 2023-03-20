// ignore_for_file: avoid_web_libraries_in_flutter, depend_on_referenced_packages

@JS()
library predict;

import 'dart:html';

import 'package:js/js.dart';

@JS('loadImageClassification')
external Object loadImageClassification();

@JS('classify')
external Object classify(ImageElement img);
