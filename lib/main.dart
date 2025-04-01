import 'package:autopark_appmovil/screens/signin_screen.dart';
// import 'package:autopark_appmovil/screens/signin_screen.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';
import 'package:autopark_appmovil/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AutoPark',
        home: const WelcomeScreen(
            userName: 'Juanito'), // Pasa el nombre de usuario aquí
        routes: {
          '/home': (context) =>
              SigninScreen() // Reemplaza con tu página principal
        },
      ),
    );
  }
}