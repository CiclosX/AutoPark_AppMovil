import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/screens/login_screen.dart';
import 'package:autopark_appmovil/screens/register_screen.dart';
import 'package:autopark_appmovil/screens/welcome_screen.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<RealtimeDbService>(
          create: (_) => RealtimeDbService(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AutoPark',
        home: AuthWrapper(),
        routes: {
          '/welcome': (context) => const WelcomeScreen(userName: 'Juanito'),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}

// Determina si el usuario está autenticado
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return LoginScreen(); // Si no hay sesión, muestra la pantalla de login
    } else {
      return HomeScreen(); // Si hay sesión, muestra la pantalla principal
      // return WelcomeScreen(userName: user.displayName ?? 'Usuario'); // Si hay sesión, muestra la pantalla de bienvenida
      // return const HomeScreen();
     // Si hay sesión, muestra la pantalla principal
    }
  }
}
