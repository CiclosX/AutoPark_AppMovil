import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecuperarDatosReservasScreen extends StatefulWidget {
  @override
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

      debugPrint('Reservas cargadas: $_reservations');
    } catch (e) {
      debugPrint('Error loading reservations: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error al cargar reservas')));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reservas',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF2196F3), // Color azul como en la imagen
        centerTitle: true,
        elevation: 5,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _reservations.isEmpty
              ? const Center(
                child: Text(
                  'No hay reservas registradas',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _reservations.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final entry = _reservations.entries.elementAt(index);
                  return _buildReservationCard(entry.key, entry.value);
                },
              ),
    );
  }

  Widget _buildReservationCard(
    DateTime date,
    List<Map<String, dynamic>> reservations,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            ...reservations.map((reserva) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hora: ${reserva['hora']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.indigoAccent,
                      ),
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

  Future<void> _confirmDeleteReservation(String docId) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: const Text('¿Deseas eliminar esta reserva?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _deleteReservation(docId);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
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
}
