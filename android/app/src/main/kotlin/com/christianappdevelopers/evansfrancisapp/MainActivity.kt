package com.christianappdevelopers.evansfrancisapp
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel.Result
class MainActivity: FlutterActivity() {
    private val CHANNEL = "youtube_channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call: MethodCall, result: MethodChannel.Result ->
                when (call.method) {
                    "playYouTubeVideo" -> {
                        val videoUrl = call.argument<String>("videoUrl")
                        if (videoUrl != null) {
                            playYouTubeVideo(videoUrl)
                            result.success(null)
                        } else {
                            result.error("INVALID_ARGUMENT", "Invalid video URL", null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }
    }

    private fun playYouTubeVideo(videoUrl: String) {
        // Implement code to open a WebView or custom activity to show the YouTube video.
        // You can use the videoUrl parameter to load the YouTube video.
        // Make sure to handle the WebView or activity lifecycle appropriately.
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(videoUrl))
        startActivity(intent)
    }
}
