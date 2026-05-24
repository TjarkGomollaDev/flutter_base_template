import 'package:firebase_auth/firebase_auth.dart';
import 'package:mark_lxxxv/4th_layer_infrastructure/models/auth_user_model.dart';

extension FirebaseUserMapper on User {
  AuthUserModel get toUserModel {
    return AuthUserModel(id: uid, email: email, name: displayName);
  }
}
