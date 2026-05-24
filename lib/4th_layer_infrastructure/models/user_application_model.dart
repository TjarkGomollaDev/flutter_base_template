import 'dart:io';
import 'package:flutter_base_template/3rd_layer_domain/entities/user_application_entity.dart';

class UserApplicationModel {
  final String userID;
  final String username;
  final bool isOnline;
  final List<String> chats;
  final List<String> aiChats;
  final String? profilePictureUrl;
  final List<String>? contacts;

  UserApplicationModel({
    required this.userID,
    required this.username,
    required this.isOnline,
    required this.chats,
    required this.aiChats,
    this.profilePictureUrl,
    this.contacts,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'username': username,
      'isOnline': isOnline,
      'chats': chats,
      'aiChats': aiChats,
      'profilePictureUrl': profilePictureUrl,
      'contacts': contacts,
    };
  }

  factory UserApplicationModel.fromMap(Map<String, dynamic> map) {
    return UserApplicationModel(
      userID: map['userID'] as String,
      username: map['username'] as String,
      isOnline: map['isOnline'] as bool,
      chats: List<String>.from(map['chats']),
      aiChats: List<String>.from(map['aiChats']),
      profilePictureUrl: map['profilePictureUrl'] as String?,
      contacts: map['contacts'] != null ? List<String>.from(map['contacts']) : null,
    );
  }

  UserApplicationEntity toDomain({
    File? profilePicture,
  }) {
    return UserApplicationEntity(
      userID: userID,
      username: username,
      isOnline: isOnline,
      chats: chats,
      aiChats: aiChats,
      profilePicture: profilePicture,
      contacts: contacts,
    );
  }

  factory UserApplicationModel.fromDomain(
    UserApplicationEntity applicationUserEntity, {
    String? profilePictureUrl,
  }) {
    return UserApplicationModel(
      userID: applicationUserEntity.userID,
      username: applicationUserEntity.username,
      isOnline: applicationUserEntity.isOnline,
      chats: applicationUserEntity.chats,
      aiChats: applicationUserEntity.aiChats,
      profilePictureUrl: profilePictureUrl,
      contacts: applicationUserEntity.contacts,
    );
  }
}
