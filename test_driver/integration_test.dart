import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// Test driver entrypoint used by `flutter drive` for integration tests.
///
/// The [integrationDriver.onScreenshot] callback receives the raw PNG bytes
/// captured via `binding.takeScreenshot(name)` and persists them to
/// `integration_test/screenshots/<name>.png`, creating the directory if it
/// does not yet exist.
Future<void> main() async {
  await integrationDriver(
    onScreenshot: (
      String screenshotName,
      List<int> screenshotBytes, [
      Map<String, Object?>? args,
    ]) async {
      final directory = Directory('integration_test/screenshots');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final file = File('${directory.path}/$screenshotName.png');
      file.writeAsBytesSync(screenshotBytes);

      // Returning true signals a successful screenshot capture.
      return true;
    },
  );
}
