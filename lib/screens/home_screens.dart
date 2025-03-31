import 'package:autopark_appmovil/screens/floor_overview_screen.dart';
import 'package:flutter/material.dart'; // Importa la pantalla de tarifas

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenido',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[800],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Aldo', // Puedes cambiar este nombre si lo deseas
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Administrador Juaguin',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Tarifa de conocimiento',
              subtitle: '10.50 s/m',
              icon: Icons.attach_money,
              color: Colors.blue,
            ),
            _buildCard(
              title: 'Agregar Lugares',
              subtitle: '15 Cajones Actualmente',
              icon: Icons.add_location,
              color: Colors.green,
            ),
            _buildCard(
              title: 'Disponibilidad Actual',
              subtitle: 'Espacios Disponibles',
              icon: Icons.event_available,
              color: Colors.orange,
              onPressed: () {
                // Navegar a ParkingScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const FloorOverviewScreen(), // Pasa el parámetro necesario
                  ),
                );
              },
            ),
            _buildCard(
              title: 'Estabilidad',
              subtitle: '7 t = 31 ms',
              icon: Icons.trending_up,
              color: Colors.purple,
            ),
            _buildCard(
              title: 'Gestionar Reservas',
              subtitle: '6 Reservas',
              icon: Icons.calendar_today,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icono de la tarjeta (ahora es un botón)
            IconButton(
              icon: Icon(icon, color: color, size: 40),
              onPressed: onPressed, // Asignamos la función onPressed aquí
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
