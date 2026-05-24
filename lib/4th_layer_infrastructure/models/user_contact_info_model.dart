import 'package:flutter_base_template/3rd_layer_domain/entities/user_contact_info_entity.dart';

class UserContactInfoModel {
  final String userID;
  final String username;
  final String? profilePictureUrl;

  UserContactInfoModel({
    required this.userID,
    required this.username,
    required this.profilePictureUrl,
  });

  // data should only be read and not processed from the database
  // therefore the methods fromMap and toDomain are sufficient
  factory UserContactInfoModel.fromMap(Map<String, dynamic> map) {
    return UserContactInfoModel(
      userID: map['userID'] as String,
      username: map['username'] as String,
      profilePictureUrl: map['profilePictureUrl'] as String?,
    );
  }

  UserContactInfoEntity toDomain() {
    return UserContactInfoEntity(
      userID: userID,
      username: username,
      profilePictureUrl: profilePictureUrl,
    );
  }
}
