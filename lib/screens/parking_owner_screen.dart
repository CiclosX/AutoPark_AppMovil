import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_screen.dart';

class ParkingOverviewScreen extends StatelessWidget {
  const ParkingOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> espacios = [
      {'id': 'espacio_1', 'nombre': 'Espacio 1', 'cajones': 15, 'color': Colors.blue},
      {'id': 'espacio_2', 'nombre': 'Espacio 2', 'cajones': 10, 'color': Colors.blue},
      {'id': 'espacio_3', 'nombre': 'Espacio 3', 'cajones': 8, 'color': Colors.blue},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lugares',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(espacios.length, (index) {
            return _buildCard(
              context: context,
              title: ' ${espacios[index]['nombre']}',
              subtitle: 'Ver más detalles',
              icon: Icons.local_parking,
              color: espacios[index]['color'],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingScreen(
                      espacioId: espacios[index]['id'],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 40),
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
      ),
    );
  }
}
