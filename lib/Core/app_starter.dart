import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import 'package:flutter_starter_template/app/my_app.dart';

class Bootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");

    // DB init
    // Firebase init
    // Supabase init
    // Dependency injection
    // Error handlers
    // Logger setup

    runApp(
      const MyApp(),
    ); // my app is initilized with a PlaceHolder() instead of an actual screen. Change it!
  }
}
