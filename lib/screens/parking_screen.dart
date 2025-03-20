import 'package:autopark_appmovil/services/realtime_db_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ParkingScreen extends StatelessWidget {
  final String espacioId;

  const ParkingScreen({super.key, required this.espacioId});

  @override
  Widget build(BuildContext context) {
    final realtimeDbService = Provider.of<RealtimeDbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Estado del Espacio $espacioId'),
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: realtimeDbService.getEstadoEspacio(espacioId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          }

          final estado = snapshot.data!['estado'];
          final timestamp = snapshot.data!['timestamp'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_parking,
                color: estado == 'ocupado' ? Colors.red : Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                'Espacio $espacioId: ${estado.toUpperCase()}',
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                'Última actualización: ${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(timestamp)).inMinutes} min',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
        },
      ),
    );
  }
}