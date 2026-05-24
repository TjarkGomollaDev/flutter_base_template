import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/auth_third_party_model.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/auth_user_model.dart';

abstract class InterfaceAuthRepository {
  // sign in with email and password
  Future<void> signInWithEmailAndPassword({required String email, required String password});

  // third party sign in
  Future<GoogleSignInAccount> signInWithGooglePart1();
  Future<AuthThirdPartyModel> signInWithGooglePart2({required GoogleSignInAccount googleUser});
  Future<void> signInWithApple();
  Future<void> thirdPartySignInWithCredential({required AuthCredential authCredential});

  // sign up with email and password
  Future<AuthUserModel> signUpWithEmailAndPassword(
      {required String email, required String password});

  // reset password
  Future<void> sendEmailToResetPassword({required String email});

  // auth current app user
  AuthUserModel get currentAuthUser;

  // auth state changes
  Stream<AuthUserModel> get authStateChanges;

  // sign out
  Future<void> signOut();
}
