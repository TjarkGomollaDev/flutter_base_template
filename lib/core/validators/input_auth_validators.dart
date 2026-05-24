// ignore_for_file: constant_identifier_names

abstract class InputAuthValidators {
  static const EMPTY_FIELD_MSG = 'Field cannot be empty.';
  static const INVALID_EMAIL_MSG = 'Invalid Email format.';
  static const WEAK_PASSWORD_MSG =
      'Weak password. Must contain 8-32 characters, including 1 upper, 1 lower, 1 digit and 1 special.';
  static const PASSWORD_MISMATCH_MSG = 'Passwords do not match.';

  static bool validateInputIsNotEmpty({required String input}) {
    if (input.isNotEmpty) {
      return true;
    }
    return false;
  }

  static String? validateEmailFormat({required String input}) {
    const emailRegex = r"""^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$""";
    if (input.isEmpty) {
      return EMPTY_FIELD_MSG;
    } else if (RegExp(emailRegex).hasMatch(input)) {
      return null;
    }
    return INVALID_EMAIL_MSG;
  }

  // has minimum 8 and maximum 32 characters in length -> adjust it by modifying: {8,32}
  // at least one uppercase English letter -> you can remove this condition by removing: (?=.*?[A-Z])
  // at least one lowercase English letter -> you can remove this condition by removing: (?=.*?[a-z])
  // at least one digitm -> you can remove this condition by removing: (?=.*\d)
  // at least one special character -> you can remove this condition by removing: (?=.*?[#?!@$%^&*-])
  static String? validateStrongPassword({required String input}) {
    const passwordRegex =
        r"""^(?=.*[A-ZÄÖÜ])(?=.*[a-zäöüß])(?=.*\d)(?=.*[-_!@#\$%^&*(),.?\":{}|<>])[A-Za-zÄÖÜäöüß\d-_!@#\$%^&*(),.?\":{}|<>]{8,32}$""";
    if (input.isEmpty) {
      return EMPTY_FIELD_MSG;
    } else if (RegExp(passwordRegex).hasMatch(input)) {
      return null;
    }
    return WEAK_PASSWORD_MSG;
  }

  static String? validateConfirmPassword({required String input, required String inputConfirm}) {
    if (inputConfirm.isEmpty) {
      return EMPTY_FIELD_MSG;
    } else if (input == inputConfirm) {
      return null;
    }
    return PASSWORD_MISMATCH_MSG;
  }
}
