import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> init() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
}
