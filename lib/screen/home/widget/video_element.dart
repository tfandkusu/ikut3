// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

/// １つしか無いvideo要素
late VideoElement _ikutVideoElement;

/// 作成されたフラグ
bool _ikutVideoElementCreated = false;

/// 1つしかないvideo要素を取得する
VideoElement getVideoElement() {
  if (!_ikutVideoElementCreated) {
    final videoElement = VideoElement();
    // ソースが設定されたら自動再生
    videoElement.autoplay = true;
    // Webカメラへの接続を要求する
    window.navigator.getUserMedia(video: true).then((stream) {
      // Webカメラへの接続が成功
      videoElement.srcObject = stream;
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
