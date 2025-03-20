import 'package:autopark_appmovil/screens/parking_screen.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart'; // Asegúrate de importar RealtimeDbService
import 'package:autopark_appmovil/widgets/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Proveer RealtimeDbService a toda la aplicación
        Provider<RealtimeDbService>(
          create: (_) => RealtimeDbService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase CRUD',
        theme: customTheme,
        home: const ParkingScreen(espacioId: 'espacio_1'),  // Puedes poner un valor real para `espacioId` aquí
      ),
    );
  }
}
