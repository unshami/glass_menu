import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_feed_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const GlassMenuApp());
}

class GlassMenuApp extends StatefulWidget {
  const GlassMenuApp({super.key});

  @override
  State<GlassMenuApp> createState() => _GlassMenuAppState();
}

class _GlassMenuAppState extends State<GlassMenuApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Menu Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC41200),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFC41200),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeFeedScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeModeChanged: _toggleTheme,
      ),
    );
  }
}
