# video_player_web_dash

Supports dash on chrome and other browsers. Forked from [video_player_web_hls](https://github.com/balvinderz/video_player_web_hls)



## Usage


```yaml
...
dependencies:
  ...
  video_player: ^2.7.0
  video_player_web_dash: 
    git:
      url: https://github.com/AR-CADE/video_player_web_dash.git
  ...
```

 Add
```javascript
 <script src="http://cdn.dashjs.org/latest/dash.all.min.js"  type="application/javascript"></script>
 ```
 
 in index.html above   
```javascript
 <script src="main.dart.js (or flutter.js)" ...></script>
```
 
## dart:io

The Web platform does **not** suppport `dart:io`, so attempts to create a `VideoPlayerController.file` will throw an `UnimplementedError`.

## Autoplay
Playing videos without prior interaction with the site might be prohibited
by the browser and lead to runtime errors. See also: https://developer.chrome.com/blog/autoplay/.

## Supported Formats

**Different web browsers support different sets of video codecs.**

### Video codecs?

Check MDN's [**Web video codec guide**](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Video_codecs) to learn more about the pros and cons of each video codec.

### What codecs are supported?

Visit [**caniuse.com: 'video format'**](https://caniuse.com/#search=video%20format) for a breakdown of which browsers support what codecs. You can customize charts there for the users of your particular website(s).

Here's an abridged version of the data from caniuse, for a Global audience:

#### MPEG-4/H.264
[![Data on Global support for the MPEG-4/H.264 video format](https://caniuse.bitsofco.de/image/mpeg4.png)](https://caniuse.com/#feat=mpeg4)

#### WebM
[![Data on Global support for the WebM video format](https://caniuse.bitsofco.de/image/webm.png)](https://caniuse.com/#feat=webm)

#### Ogg/Theora
[![Data on Global support for the Ogg/Theora video format](https://caniuse.bitsofco.de/image/ogv.png)](https://caniuse.com/#feat=ogv)

#### AV1
[![Data on Global support for the AV1 video format](https://caniuse.bitsofco.de/image/av1.png)](https://caniuse.com/#feat=av1)

#### HEVC/H.265
[![Data on Global support for the HEVC/H.265 video format](https://caniuse.bitsofco.de/image/hevc.png)](https://caniuse.com/#feat=hevc)


[1]: ../video_player

## Example

```dart
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://dash.akamaized.net/dash264/TestCasesUHD/2b/11/MultiRate.mpd')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: Scaffold(
        body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
```
