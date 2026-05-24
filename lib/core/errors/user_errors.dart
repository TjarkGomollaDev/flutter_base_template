class ErrorUserGeneral extends Error {
  static const message = 'Oops. Something went wrong when accessing our database.';

  @override
  String toString() {
    return message;
  }
}

class ErrorUserAdNewAiChat extends Error {}
