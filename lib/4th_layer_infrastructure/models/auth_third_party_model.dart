import 'package:firebase_auth/firebase_auth.dart';

class AuthThirdPartyModel {
  final String id;
  final AuthCredential authCredential;

  const AuthThirdPartyModel({required this.id, required this.authCredential});
}
