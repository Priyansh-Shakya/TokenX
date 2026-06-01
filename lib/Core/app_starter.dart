import "package:flutter/material.dart";
import 'package:flutter_starter_template/app/my_app.dart';

class Bootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Optional async initialization can go here.

    runApp(const TokenXApp());
  }
}
