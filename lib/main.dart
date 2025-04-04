import 'package:autopark_appmovil/screens/auth_scren.dart';
import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart'; // Nueva importación
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<RealtimeDbService>(create: (_) => RealtimeDbService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Nuevo Provider
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AutoPark',
            theme: ThemeData.light().copyWith(
              // Tu tema claro personalizado
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              // Tu tema oscuro personalizado
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black87,
                foregroundColor: Colors.white,
              ),
              cardTheme: CardTheme(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey[800],
              ),
            ),
            themeMode: themeProvider.themeMode, // Usamos el themeMode del provider
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<AuthService>(context, listen: false).user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}