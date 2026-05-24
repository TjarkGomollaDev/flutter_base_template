import 'dart:math';

class Generators {
  static String generateRandomUsername() {
    final random = Random();
    String username = 'anonym';
    for (var i = 0; i < 4; i++) {
      username += random.nextInt(10).toString();
    }
    return username;
  }
}
