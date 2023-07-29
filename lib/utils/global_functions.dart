import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:evansfrancisapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

logger(var str, {String? hint, bool json = false}) {
  if (GlobalConstants.enableLogger) {
    debugPrint(hint != null ? "-----$hint------" : '-------');
    if (json) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(str));
    } else {
      debugPrint(str.toString());
    }
    debugPrint(hint != null ? "-----$hint------" : '-------');
  }
}

///////////
bool isYouTubeLink(String link) {
  if (link.startsWith("https://www.youtube.com/")) {
    if (link.contains("watch?v=")) {
      return true;
    }
  }
  return false;
}
///////////

///////////

//launch url function
Future<bool> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    return await launchUrl(uri);
  } else {
    return false;
  }
}

///////////
