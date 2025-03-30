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
        // Usamos Provider directamente en lugar de ChangeNotifierProvider
        Provider<RealtimeDbService>(
          create: (_) => RealtimeDbService(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase CRUD',
        home: WelcomeScreen(),
        //home: WelcomeScreen(),
      ),
    );
  }
}
