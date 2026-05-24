import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_storage_repository.dart';
import 'package:flutter_base_template/core/errors/storage_errors.dart';

class StorageRepository implements InterfaceStorageRepository {
  final FirebaseStorage _storage;

  StorageRepository({required FirebaseStorage storage}) : _storage = storage;

  Future<String> storeFileToFirebaseAndGetUrl({
    required File file,
    required String reference,
  }) async {
    try {
      final uploadTask = _storage.ref().child(reference).putFile(file);
      var snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (_) {
      throw ErrorStorageGeneral();
    }
  }

  // für später, wenn wir eine Datei wirklich runterladen und lokal speichern wollen
  // eventuell keine Datei zurückgeben, sondern einfach nur file.path
  Future<File> getFileFromFirebase({required String reference}) async {
    final storageRef = _storage.ref().child(reference);
    File file = File('assets/user_data/${storageRef.name}'); // in pubspec.yaml hinzufügen
    await storageRef.writeToFile(file);
    return file;
  }
}
