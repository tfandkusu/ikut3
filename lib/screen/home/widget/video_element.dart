// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import '../../../util/media/media_js.dart';

/// １つしか無いvideo要素
late VideoElement _ikutVideoElement;

/// 作成されたフラグ
bool _ikutVideoElementCreated = false;

/// 1つしかないvideo要素を取得する
VideoElement getVideoElement({Function? onCameraStart}) {
  if (!_ikutVideoElementCreated) {
    final videoElement = VideoElement();
    // ソースが設定されたら自動再生
    videoElement.autoplay = true;
    // Webカメラへの接続を要求する
    window.navigator.getUserMedia(video: true).then((stream) {
      // Webカメラへの接続が成功
      videoElement.srcObject = stream;
      onCameraStart?.call();
      // TODO
      // できればラベルにOBSが付いているデバイスを選択したいが
      // 接続してからで無いと取得できない。
      // https://developer.mozilla.org/ja/docs/Web/API/MediaDeviceInfo
      window.navigator.mediaDevices?.enumerateDevices().then((devices) {
        for (var mediaDeviceInfo in devices) {
          // ignore: unused_local_variable
          final deviceId = getMediaDeviceInfoDeviceId(mediaDeviceInfo);
          // ignore: unused_local_variable
          final kind = getMediaDeviceInfoKind(mediaDeviceInfo);
          // ignore: unused_local_variable
          final label = getMediaDeviceInfoLabel(mediaDeviceInfo);
          // print("deviceId = $deviceId kind = $kind label = $label");
        }
      });
    });
    videoElement.id = 'video';
    videoElement.controls = false;
    videoElement.style.width = '100%';
    videoElement.style.height = '100%';

    _ikutVideoElement = videoElement;
    _ikutVideoElementCreated = true;
  }
  return _ikutVideoElement;
}

VideoElement? getVideoElementIfCreated() {
  if (_ikutVideoElementCreated) {
    return _ikutVideoElement;
  } else {
    return null;
  }
}
