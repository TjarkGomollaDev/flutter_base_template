// lowest and most unspecific error level in the app
class ErrorUnknown extends Error {
  static const message = 'Unknown issue. Please retry or reach out to our support.';

  @override
  String toString() {
    return message;
  }
}
