import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/contact_controller.dart';
import 'controllers/theme_controller.dart';
import 'theme/app_theme.dart';
import 'views/home_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            title: 'Contacts App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeController.themeMode,
            home: const HomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
