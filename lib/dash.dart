@JS()
library dash.js;

import 'dart:html';

import 'package:js/js.dart';

@JS('dashjs')
class DashJS {
  @JS()
  // ignore: non_constant_identifier_names
  external static DashMediaPlayer MediaPlayer();
}

@JS()
class DashMediaPlayer {
  @JS()
  external bool isReady();

  @JS()
  external bool getVersion();

  @JS()
  // ignore: avoid_positional_boolean_parameters
  external void initialize(VideoElement video, String videoSrc, bool? autoPlay);

  @JS()
  external Future<bool> destroy();

  @JS()
  external DashMediaPlayer create();

  @JS()
  external bool extend(String parentName, Function config);

  @JS()
  external void on(String event, void Function(DashErrorEvent) callback);

  @JS()
  external void off(String event, void Function(DashErrorEvent) callback);
}

@JS()
@anonymous
class DashExtendConfig {
  external factory DashExtendConfig({Function modifyRequestHeader});
  @JS()
  external Function get modifyRequestHeader;
}

@JS()
class DashErrorEvent {
  @JS()
  external String get type;

  @JS()
  external Object get error;
}

@JS()
class DashMediaPlayerErrorEvent {
  @JS()
  external int get code;

  @JS()
  external String get message;

  @JS()
  external Object get data;
}
