import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';

class ParkingScreen extends StatelessWidget {
  final String espacioId;
  final String espacioNombre; // Nuevo parámetro para el nombre del espacio

  const ParkingScreen({super.key, required this.espacioId, required this.espacioNombre});

  @override
  Widget build(BuildContext context) {
    final realtimeDbService = Provider.of<RealtimeDbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estado de $espacioNombre', // Muestra el nombre del espacio
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Map<String, dynamic>>(
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
            final ultimaActualizacion = snapshot.data!['ultima_actualizacion'];

            DateTime? ultimaFecha;
            try {
              ultimaFecha = DateTime.parse(ultimaActualizacion);
            } catch (e) {
              ultimaFecha = null;
            }

            return Center( // Centrado de todo el contenido
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centrado vertical
                crossAxisAlignment: CrossAxisAlignment.center, // Centrado horizontal
                children: [
                  Icon(
                    Icons.local_parking,
                    color: estado == 'ocupado' ? Colors.red : Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$espacioNombre: ${estado.toUpperCase()}', // Usa el nombre real
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ultimaFecha != null
                        ? 'Última actualización: ${ultimaFecha.toLocal()}'
                        : 'Última actualización: desconocida',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Acción cuando se presiona el botón
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Actualizar Estado',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
