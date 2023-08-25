// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html';
import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_web_dash/src/video_player.dart';

/// The web implementation of [VideoPlayerPlatform].
///
/// This class implements the `package:video_player` functionality for the web.
class VideoPlayerPluginDash extends VideoPlayerPlatform {
  /// Registers this class as the default instance of [VideoPlayerPlatform].
  static void registerWith(Registrar registrar) {
    VideoPlayerPlatform.instance = VideoPlayerPluginDash();
  }

  // Map of textureId -> VideoPlayer instances
  final Map<int, VideoPlayer> _videoPlayers = <int, VideoPlayer>{};

  // Simulate the native "textureId".
  int _textureCounter = 1;

  @override
  Future<void> init() async {
    return _disposeAllPlayers();
  }

  @override
  Future<void> dispose(int textureId) async {
    _player(textureId).dispose();
    _videoPlayers.remove(textureId);
    return;
  }

  void _disposeAllPlayers() {
    for (final videoPlayer in _videoPlayers.values) {
      videoPlayer.dispose();
    }
    _videoPlayers.clear();
  }

  @override
  Future<int> create(DataSource dataSource) async {
    final textureId = _textureCounter++;

    late String uri;

    Map<String, String>? headers;

    switch (dataSource.sourceType) {
      case DataSourceType.network:
        {
          // Do NOT modify the incoming uri, it can be a Blob,
          // and Safari doesn't like blobs that have changed.
          uri = dataSource.uri ?? '';
          headers = dataSource.httpHeaders;
          break;
        }
      case DataSourceType.asset:
        {
          var assetUrl = dataSource.asset!;
          if (dataSource.package != null && dataSource.package!.isNotEmpty) {
            assetUrl = 'packages/${dataSource.package}/$assetUrl';
          }
          assetUrl = assetManager.getAssetUrl(assetUrl);
          uri = assetUrl;
          break;
        }
      case DataSourceType.file:
        return Future<int>.error(
          UnimplementedError(
            'web implementation of video_player cannot play local files',
          ),
        );
      case DataSourceType.contentUri:
        return Future<int>.error(
          UnimplementedError(
            'web implementation of video_player cannot play content uri',
          ),
        );
    }

    final videoElement = VideoElement()
      ..id = 'videoElement-$textureId'
      ..style.border = 'none'
      ..style.height = '100%'
      ..style.width = '100%';

    videoElement.attributes['playsinline'] = 'true';

    // TODO(hterkelsen): Use initialization parameters once they are available
    platformViewRegistry.registerViewFactory(
      'videoPlayer-$textureId',
      (int viewId) => videoElement,
    );

    final player = VideoPlayer(
      videoElement: videoElement,
      uri: uri,
      headers: headers ?? <String, String>{},
    );

    await player.initialize();

    _videoPlayers[textureId] = player;

    return textureId;
  }

  @override
  Future<void> setLooping(int textureId, bool looping) async {
    return _player(textureId).setLooping(looping);
  }

  @override
  Future<void> play(int textureId) async {
    return _player(textureId).play();
  }

  @override
  Future<void> pause(int textureId) async {
    return _player(textureId).pause();
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {
    return _player(textureId).setVolume(volume);
  }

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) async {
    return _player(textureId).setPlaybackSpeed(speed);
  }

  @override
  Future<void> seekTo(int textureId, Duration position) async {
    return _player(textureId).seekTo(position);
  }

  @override
  Future<Duration> getPosition(int textureId) async {
    return _player(textureId).getPosition();
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) {
    return _player(textureId).events;
  }

  // Retrieves a [VideoPlayer] by its internal `id`.
  // It must have been created earlier from the [create] method.
  VideoPlayer _player(int id) {
    return _videoPlayers[id]!;
  }

  @override
  Widget buildView(int textureId) {
    return HtmlElementView(viewType: 'videoPlayer-$textureId');
  }

  /// Sets the audio mode to mix with other sources (ignored)
  @override
  Future<void> setMixWithOthers(bool mixWithOthers) => Future<void>.value();
}