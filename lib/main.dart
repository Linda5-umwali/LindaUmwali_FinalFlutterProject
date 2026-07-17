import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:alu_connect/screens/splash.dart';
import 'package:alu_connect/theme/app_theme_controller.dart';

const Color aluDarkBlue = Color(0xFF001A5B);
const Color aluRed = Color(0xFFB00020);
const Color aluWhite = Color(0xFFFFFFFF);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const AluConnectApp());
}

class AluConnectApp extends StatefulWidget {
  const AluConnectApp({super.key});

  @override
  State<AluConnectApp> createState() => _AluConnectAppState();
}

class _AluConnectAppState extends State<AluConnectApp> {
  @override
  void initState() {
    super.initState();
    AppThemeController.instance.load();
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final base = isDark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: aluDarkBlue,
        brightness: brightness,
        primary: aluDarkBlue,
        secondary: aluRed,
        surface: isDark
            ? const Color.from(alpha: 1, red: 0.02, green: 0.008, blue: 0.318)
            : aluWhite,
        onPrimary: aluWhite,
        onSecondary: aluWhite,
        onSurface: isDark ? aluWhite : aluDarkBlue,
      ),
      scaffoldBackgroundColor: isDark
          ? const Color.fromARGB(255, 0, 0, 59)
          : const Color(0xFFF4F7FB),
      textTheme: base.textTheme.apply(
        bodyColor: isDark ? aluWhite : aluDarkBlue,
        displayColor: isDark ? aluWhite : aluDarkBlue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: aluRed,
          foregroundColor: aluWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: aluDarkBlue,
        foregroundColor: aluWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: aluRed, width: 2),
        ),
        labelStyle: const TextStyle(color: aluDarkBlue),
        prefixIconColor: aluDarkBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppThemeController.instance,
      builder: (context, _) {
        return MaterialApp(
          title: 'ALU Catalyst',
          home: const SplashScreen(),
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: AppThemeController.instance.themeMode,
        );
      },
    );
  }
}