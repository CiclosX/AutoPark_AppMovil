import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({super.key});

  final String docId = "IIFIUX3pgbRKQdx5NJ5D"; // Reemplaza con tu ID real

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Espacio',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('espacios').doc(docId).get(),
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
                'Error al conectar con la base de datos.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.red,
                ),
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                'No se encontraron datos.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          var data = snapshot.data!;
          int capacidad = data['capacidad'];
          Timestamp horario = data['horario'];
          int tarifa = data['tarifa'];
          String ubicacion = data['ubicacion'];

          String formattedDate =
              DateFormat('dd/MM/yyyy, hh:mm a').format(horario.toDate());

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '✅ Conexión exitosa con la base de datos',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Capacidad:', '$capacidad', theme),
                const SizedBox(height: 8),
                _buildInfoRow('Horario:', formattedDate, theme),
                const SizedBox(height: 8),
                _buildInfoRow('Tarifa:', '\$${tarifa.toString()}', theme),
                const SizedBox(height: 8),
                _buildInfoRow('Ubicación:', ubicacion, theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, ThemeData theme) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ],
    );
  }
}