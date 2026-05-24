import 'dart:io';
import 'package:mark_lxxxv/core/generators/generators.dart';

class UserApplicationEntity {
  final String userID;
  final String username;
  final bool isOnline;
  final List<String> chats;
  final List<String> aiChats;
  final File? profilePicture;
  final List<String>? contacts;

  UserApplicationEntity({
    required this.userID,
    required this.username,
    required this.isOnline,
    required this.chats,
    required this.aiChats,
    this.profilePicture,
    this.contacts,
  });

  UserApplicationEntity.initializeUser({
    required String userID,
  }) : this(
          userID: userID,
          username: Generators.generateRandomUsername(),
          isOnline: false,
          chats: [],
          aiChats: [],
        );
}
