import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_base_template/3rd_layer_domain/interfaces_repositories/interface_auth_repository.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/auth_third_party_model.dart';
import 'package:flutter_base_template/4th_layer_infrastructure/models/auth_user_model.dart';
import 'package:flutter_base_template/core/errors/auth_errors.dart';
import 'package:flutter_base_template/core/errors/common_errors.dart';
import 'package:flutter_base_template/core/extensions/firebase_extensions.dart';

class AuthRepository implements InterfaceAuthRepository {
  final FirebaseAuth _firebaseAuth;
  bool _blockAutomaticSignIn = false;
  AuthUserModel _currentAuthUser = AuthUserModel.empty;

  AuthRepository({required FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  // sign in with email and password
  @override
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      // for security reasons only a general and no specific error message is thrown
      throw ErrorSignInGeneral();
    } catch (_) {
      throw ErrorUnknown();
    }
  }

  // sign in with google
  @override
  Future<GoogleSignInAccount> signInWithGooglePart1() async {
    try {
      final signIn = GoogleSignIn.instance;
      await signIn.initialize(
          clientId: '445955098972-7m7i1k20f0ohqv1iinqsf8g2m3gt6ogt.apps.googleusercontent.com');
      final googleUser = await signIn.authenticate();
      return googleUser;
    } on ErrorThirdPartySignInCancled catch (_) {
      rethrow;
    } catch (_) {
      throw ErrorUnknown();
    }
  }

  @override
  Future<AuthThirdPartyModel> signInWithGooglePart2(
      {required GoogleSignInAccount googleUser}) async {
    _blockAutomaticSignIn = true;
    try {
      final GoogleSignInClientAuthorization? auth =
          await googleUser.authorizationClient.authorizationForScopes(['email']);

      if (auth == null) {
        throw ErrorSignInWithGoogle();
      }

      final OAuthCredential authCredential =
          GoogleAuthProvider.credential(accessToken: auth.accessToken);
      // use firebase to Sign In
      final userCredential = await _firebaseAuth.signInWithCredential(authCredential);
      // perform a manual Sign Out, for more detailed information see sign_in_bloc.dart
      await signOut();
      _blockAutomaticSignIn = false;
      return AuthThirdPartyModel(id: userCredential.user!.uid, authCredential: authCredential);
    } on FirebaseAuthException catch (_) {
      _blockAutomaticSignIn = false;
      throw ErrorSignInWithGoogle();
    } catch (_) {
      _blockAutomaticSignIn = false;
      throw ErrorUnknown();
    }
  }

  // sign in with apple
  @override
  Future<void> signInWithApple() async {}

  // method used in connection with third party sign in
  @override
  Future<void> thirdPartySignInWithCredential({required AuthCredential authCredential}) async {
    try {
      await _firebaseAuth.signInWithCredential(authCredential);
    } on FirebaseAuthException catch (_) {
      throw ErrorSignInWithGoogle();
    } catch (_) {
      throw ErrorUnknown();
    }
  }

  // sign up with email and password
  @override
  Future<AuthUserModel> signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    _blockAutomaticSignIn = true;
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // perform a manual sign out, as the firebase method logs us in automatically
      await signOut();
      _blockAutomaticSignIn = false;
      return userCredential.user!.toUserModel;
    } on FirebaseAuthException catch (e) {
      _blockAutomaticSignIn = false;
      switch (e.code) {
        case 'email-already-in-use':
          throw ErrorSignUpEmailAlreadyInUse();
        default:
          throw ErrorSignUpGeneralFailure();
      }
    } catch (_) {
      _blockAutomaticSignIn = false;
      throw ErrorUnknown();
    }
  }

  // reset password
  @override
  Future<void> sendEmailToResetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (_) {
      throw ErrorResetPassword();
    } catch (_) {
      throw ErrorUnknown();
    }
  }

  // auth current app user
  @override
  AuthUserModel get currentAuthUser => _currentAuthUser;

  // auth state changes
  @override
  Stream<AuthUserModel> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      // block the automatic sign in in case of sign up
      if (_blockAutomaticSignIn) {
        return AuthUserModel.empty;
      }
      final user = firebaseUser == null ? AuthUserModel.empty : firebaseUser.toUserModel;
      _currentAuthUser = user;
      return user;
    });
  }

  // sign out
  @override
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {
      throw ErrorUnknown();
    }
  }
}
