import 'dart:typed_data';

import 'package:dependency_plugin/dependency_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  //create singleton
  static final FireStorage _fireStorage = FireStorage._internal();

  FireStorage._internal();

  factory FireStorage() => _fireStorage;

  //create instance
  static FireStorage get instance => _fireStorage;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  FirebaseStorage get storage => _storage;

  String get storageBucket => _storage.bucket;

  //Get reference
  Reference getReference(String path) {
    return _storage.ref(path);
  }

  //Upload file
  Future<Either<String, String>> uploadData(
      {required Uint8List data, required String path}) async {
    try {
      await _storage
          .ref(path)
          .putData(data, SettableMetadata(contentType: 'image/png'));
      Logger.i('File uploaded successfully');
      return const Right('Success');
    } catch (e) {
      Logger.e(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> uploadFile(
      {required dynamic file, required String path}) async {
    try {
      await _storage
          .ref(path)
          .putFile(file, SettableMetadata(contentType: 'image/png'));
      Logger.i('File uploaded successfully');
      return const Right('Success');
    } catch (e) {
      Logger.e(e.toString());
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteImage(String path) async {
    try {
      await firestoreHandler(getReference(path).delete());
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //Delete recursively
  Future<Either<String, void>> deleteFolder(String path) async {
    try {
      final items =
          await getReference(path).listAll().then((value) => value.items);
      for (final item in items) {
        try {
          item.delete();
        } catch (e) {
          Logger.e(e.toString());
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ListResult>> getImages(String path) async {
    try {
      final res = await getReference(path).listAll();
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //upload image to storage
  Future<Either<String, String>> uploadImage(
      {required Uint8List data, required String path}) async {
    try {
      final res = await uploadData(data: data, path: path);
      if (res.isLeft) {
        //error
        Logger.e("Error uploading image: ${res.left}");
        return Left(res.left);
      }
      return Right(res.right);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
