// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/user_application_entity.dart';
import 'package:mark_lxxxv/3rd_layer_domain/entities/user_contact_info_entity.dart';
import 'package:mark_lxxxv/3rd_layer_domain/interfaces_repositories/interface_user_repository.dart';
import 'package:mark_lxxxv/4th_layer_infrastructure/models/user_application_model.dart';
import 'package:mark_lxxxv/4th_layer_infrastructure/models/user_contact_info_model.dart';
import 'package:mark_lxxxv/core/errors/user_errors.dart';

class UserRepository implements InterfaceUserRepository {
  static const String _COLLECTION_USERS = 'users';
  static const String _FIELD_AI_CHATS = 'aiChats';
  final FirebaseFirestore _firestore;
  late UserContactInfoEntity _currentUserContactInfo;

  UserRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  // checks if a given user exists in the Firestore Database
  @override
  Future<bool> isUserDocumentExisting({required String userID}) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userID).get();
      return snapshot.exists;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> isAnyAiChatExisting({required String userID}) async {
    try {
      final snapshot = await _firestore.collection(_COLLECTION_USERS).doc(userID).get();
      final userAiChats = snapshot.data()![_FIELD_AI_CHATS] as List<dynamic>;
      return userAiChats.isEmpty ? null : userAiChats.first;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addNewAiChat({required String aiChatID, required String userID}) async {
    try {
      await _firestore.collection(_COLLECTION_USERS).doc(userID).update({
        _FIELD_AI_CHATS: FieldValue.arrayUnion([aiChatID]),
      });
    } catch (_) {
      throw ErrorUserAdNewAiChat();
    }
  }

  // add and initialize a new user to the Firestore Database
  @override
  Future<void> initUserDocument({required UserApplicationEntity applicationUserEntity}) async {
    try {
      final applicationUserModel = UserApplicationModel.fromDomain(applicationUserEntity);
      await _firestore
          .collection('users')
          .doc(applicationUserModel.userID)
          .set(applicationUserModel.toMap());
    } catch (_) {
      debugPrint('init');
      throw ErrorUserGeneral();
    }
  }

  // loads the contact info of the current user and saves it in the user repository
  @override
  Future<void> loadCurrrentUserContactInfo({required String userID}) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userID).get();
      _currentUserContactInfo = UserContactInfoModel.fromMap(snapshot.data()!).toDomain();
      debugPrint('oköö');
    } catch (_) {
      debugPrint('load');
      throw ErrorUserGeneral();
    }
  }

  // getter contact info of the current user
  @override
  UserContactInfoEntity get currentUserContactInfo => _currentUserContactInfo;

  // ab hier noch nicht alles perfekt
  @override
  Future<UserContactInfoEntity> getContactInfo({required String userID}) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userID).get();
      return UserContactInfoModel.fromMap(snapshot.data()!).toDomain();
    } catch (_) {
      throw ErrorUserGeneral();
      // später den Error einbauen, falls der user nicht mehr existiert, was soll in der UI angezeigt werden?
    }
  }

  @override
  Stream<List<String>> streamChatIDs({required String userID}) {
    return _firestore.collection("users").doc(userID).snapshots().map((snapshot) {
      return UserApplicationModel.fromMap(snapshot.data()!).chats;
    });
  }
}
