import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EspaciosScreen extends StatelessWidget {
  const EspaciosScreen({super.key});

  final String docId = "IIFIUX3pgbRKQdx5NJ5D"; // Reemplaza con tu ID real

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Espacio',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('espacios').doc(docId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error al conectar con la base de datos.',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                'No se encontraron datos.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                // Mensaje de conexión exitosa en la UI
                const Center(
                  child: Text(
                    '✅ Conexión exitosa con la base de datos',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Capacidad:', '$capacidad'),
                const SizedBox(height: 8),
                _buildInfoRow('Horario:', formattedDate),
                const SizedBox(height: 8),
                _buildInfoRow('Tarifa:', '\$${tarifa.toString()}'),
                const SizedBox(height: 8),
                _buildInfoRow('Ubicación:', ubicacion),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
