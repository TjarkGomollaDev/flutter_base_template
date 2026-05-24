// chat general failure
class ErrorChatGeneral extends Error {
  static const message = 'SaveData failed with a general failure.';

  @override
  String toString() {
    return message;
  }
}
