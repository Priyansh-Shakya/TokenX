import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_template/features/shell/pages/main_shell.dart';

class TokenXApp extends StatelessWidget {
  const TokenXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TokenX',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF0F0F1E),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0F0F1E),
            elevation: 0,
          ),
        ),
        home: MainShell(),
      ),
    );
  }
}
