import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/fitness_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // iOS Durum Çubuğu (Status Bar) Ayarları
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark, // iOS için beyaz metin
      systemNavigationBarColor: AppTheme.darkBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FitPulseApp());
}

class FitPulseApp extends StatelessWidget {
  const FitPulseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FitnessProvider()),
      ],
      child: MaterialApp(
        title: 'FitPulse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        // iOS Cupertino tarzı pürüzsüz sayfa geçişleri
        themeMode: ThemeMode.dark,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
