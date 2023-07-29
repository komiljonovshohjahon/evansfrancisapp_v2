import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:admin_panel_web/utils/utils.dart';

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

////////////////

bool isYouTubeLink(String link) {
  if (link.startsWith("https://www.youtube.com/")) {
    if (link.contains("watch?v=")) {
      return true;
    }
  }
  return false;
}

/////////////////

////////////////

Future<List<PlatformFile>?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: true,
  );

  if (result != null) {
    List<PlatformFile> files = result.files;
    return files;
  }
  // User canceled the picker
  return null;
}

///////////////////
