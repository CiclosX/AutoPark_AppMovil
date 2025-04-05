import 'package:autopark_appmovil/screens/pago_qr_screen.dart' show PagoQrScreen;
import 'package:flutter/material.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/screens/reservas_screen.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class ParkingScreen extends StatelessWidget {
  final String espacioId;
  final String espacioNombre;
  final double tarifaPorHora;

  const ParkingScreen({
    super.key, 
    required this.espacioId, 
    required this.espacioNombre,
    this.tarifaPorHora = 5.0, // Valor por defecto, ajusta según necesites
  });
  
  get horaInicio => null;

  @override
  Widget build(BuildContext context) {
    final realtimeDbService = Provider.of<RealtimeDbService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estado de $espacioNombre',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Map<String, dynamic>>(
          stream: realtimeDbService.getEstadoEspacio(espacioId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No hay datos disponibles',
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                ),
              );
            }

            final estado = snapshot.data!['estado'];
            final ultimaActualizacion = snapshot.data!['ultima_actualizacion'];

            DateTime? ultimaFecha;
            try {
              ultimaFecha = DateTime.parse(ultimaActualizacion);
            } catch (e) {
              ultimaFecha = null;
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_parking,
                    color: estado == 'ocupado' ? Colors.red : Colors.green,
                    size: 100,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '$espacioNombre: ${estado.toUpperCase()}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.blue[900],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ultimaFecha != null
                        ? 'Última actualización: ${DateFormat('dd/MM/yyyy HH:mm').format(ultimaFecha.toLocal())}'
                        : 'Última actualización: desconocida',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildActionButton(
                    context: context,
                    text: 'Actualizar Estado',
                    color: primaryColor ?? Colors.blue,
                    onPressed: () {
                      // Acción para actualizar estado
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildActionButton(
                    context: context,
                    text: 'Reservas',
                    color: isDarkMode ? (Colors.orange[700] ?? Colors.orange) : (Colors.orange[800] ?? Colors.orange),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReservasScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PagoQrScreen(
                            tarifaPorHora: tarifaPorHora,
                            espacioNombre: espacioNombre,
                            horaInicio: horaInicio,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12, 
                        horizontal: 20
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Pago',
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

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}