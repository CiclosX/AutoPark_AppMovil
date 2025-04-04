import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class RecuperarDatosReservasScreen extends StatefulWidget {
  const RecuperarDatosReservasScreen({super.key});

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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              "Confirmar Eliminación",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: Text(
              "¿Estás seguro de que deseas eliminar esta reserva?",
              style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _deleteReservation(docId);
                  Navigator.pop(context);
                },
                child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
            : _reservations.isEmpty
                ? Center(
                    child: Text(
                      "No hay reservas disponibles",
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    ),
                  )
                : ListView.separated(
                    itemCount: _reservations.length,
                    separatorBuilder: (context, index) => 
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final entry = _reservations.entries.elementAt(index);
                      return _buildReservationCard(
                        entry.key, 
                        entry.value,
                        isDarkMode,
                        theme,
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildReservationCard(
    DateTime date,
    List<Map<String, dynamic>> reservations,
    bool isDarkMode,
    ThemeData theme,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, 
                    color: theme.primaryColor, size: 24),
                const SizedBox(width: 16),
                Text(
                  _formatDate(date),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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