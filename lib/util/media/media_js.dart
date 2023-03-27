// ignore_for_file: avoid_web_libraries_in_flutter, depend_on_referenced_packages

@JS()
library media;

import 'package:js/js.dart';

@JS('getMediaDeviceInfoDeviceId')
external String getMediaDeviceInfoDeviceId(Object mediaDeviceInfo);

@JS('getMediaDeviceInfoKind')
external String getMediaDeviceInfoKind(Object mediaDeviceInfo);

@JS('getMediaDeviceInfoLabel')
external String getMediaDeviceInfoLabel(Object mediaDeviceInfo);
