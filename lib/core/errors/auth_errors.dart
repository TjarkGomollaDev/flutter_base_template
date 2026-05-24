// Sign In
class ErrorSignInGeneral extends Error {
  static const message = 'Sign In Failed. Check your Email and Password combination for accuracy.';

  @override
  String toString() {
    return message;
  }
}

class ErrorSignInWithGoogle extends Error {
  static const message = 'Google Sign In Failed. Please make another attempt.';

  @override
  String toString() {
    return message;
  }
}

class ErrorSignInWithApple extends Error {
  static const message = 'Apple Sign In Failed. Please make another attempt.';

  @override
  String toString() {
    return message;
  }
}

class ErrorThirdPartySignInCancled {}

// Sign Up
class ErrorSignUpGeneralFailure extends Error {
  static const message = 'Sign Up Failed. There was an issue during registration. Please try again';

  @override
  String toString() {
    return message;
  }
}

class ErrorSignUpEmailAlreadyInUse extends Error {
  static const message = 'It seems this Email is already in use. Kindly select another Email.';

  @override
  String toString() {
    return message;
  }
}

// reset password
class ErrorResetPassword extends Error {
  static const message = 'Oops. An error occurred while sending the Email to reset your Password.';

  @override
  String toString() {
    return message;
  }
}
