import 'package:flutter/services.dart';

class YoutubePlayerPlugin {
  static const MethodChannel _channel = MethodChannel('youtube_channel');

  static Future<void> playVideo(String videoUrl) async {
    await _channel.invokeMethod('playYouTubeVideo', {'videoUrl': videoUrl});
  }
}
