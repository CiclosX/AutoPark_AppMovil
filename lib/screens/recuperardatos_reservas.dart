import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecuperarDatosReservasScreen extends StatefulWidget {
  const RecuperarDatosReservasScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RecuperarDatosReservasScreenState createState() => 
      _RecuperarDatosReservasScreenState();
}

class _RecuperarDatosReservasScreenState
    extends State<RecuperarDatosReservasScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<DateTime, List<Map<String, dynamic>>> _reservations = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('reservas').get();
      final tempReservations = <DateTime, List<Map<String, dynamic>>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final fecha = (data['fecha'] as Timestamp).toDate();
        final normalizedDate = DateTime(fecha.year, fecha.month, fecha.day);

        if (!tempReservations.containsKey(normalizedDate)) {
          tempReservations[normalizedDate] = [];
        }

        tempReservations[normalizedDate]!.add({
          'id': doc.id,
          'fechaStr': data['fechaStr'],
          'hora': data['hora'],
          'timestamp': fecha,
        });
      }

      setState(() {
        _reservations = tempReservations;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading reservations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar reservas')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteReservation(String docId) async {
    try {
      await _firestore.collection('reservas').doc(docId).delete();
      _loadReservations();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva eliminada correctamente')),
      );
    } catch (e) {
      debugPrint('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar reserva')),
      );
    }
  }

  void _confirmDeleteReservation(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar esta reserva?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteReservation(docId);
                Navigator.pop(context);
              },
              child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]} de ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _reservations.isEmpty
                ? const Center(child: Text("No hay reservas disponibles"))
                : ListView.separated(
                    itemCount: _reservations.length,
                    separatorBuilder: (context, index) => 
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final entry = _reservations.entries.elementAt(index);
                      return _buildReservationCard(entry.key, entry.value);
                    },
                  ),
      ),
    );
  }

  Widget _buildReservationCard(
    DateTime date,
    List<Map<String, dynamic>> reservations,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, 
                    color: Colors.blue, size: 24),
                const SizedBox(width: 16),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...reservations.map((reserva) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hora: ${reserva['hora']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteReservation(reserva['id']),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}