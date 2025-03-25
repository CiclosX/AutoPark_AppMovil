import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';

class ParkingScreen extends StatelessWidget {
  final String espacioId;

  const ParkingScreen({super.key, required this.espacioId});

  @override
  Widget build(BuildContext context) {
    final realtimeDbService = Provider.of<RealtimeDbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estado del Espacio $espacioId',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800], // Mismo color que en tu app
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado igual al de tu app
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900], // Color de texto consistente
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ultimaFecha != null
                      ? 'Última actualización: ${ultimaFecha.toLocal()}'
                      : 'Última actualización: desconocida',
                  style: TextStyle(
                    color: Colors.grey[600], // Color más suave para el subtítulo
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Acción cuando se presiona el botón, por ejemplo, actualizar el estado
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800], // Usamos backgroundColor para el color de fondo
                    foregroundColor: Colors.white, // Cambiamos el color del texto a blanco
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
            );
          },
        ),
      ),
    );
  }
}
