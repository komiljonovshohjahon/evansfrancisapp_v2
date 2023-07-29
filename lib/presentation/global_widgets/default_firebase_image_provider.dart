import 'package:firebase_cached_image/firebase_cached_image.dart';

// ignore: constant_identifier_names
const String _BUCKET = "gs://krci-app.appspot.com/";

class DefaultCachedFirebaseImageProvider extends FirebaseImageProvider {
  DefaultCachedFirebaseImageProvider(String path)
      : super(FirebaseUrl(_BUCKET + path));
}
