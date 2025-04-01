import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: ReservasScreen()));
}

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  Map<DateTime, List<Map<String, dynamic>>> _reservations = {};

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('reservas').get();
      
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              return _reservations[day]?.map((r) => r['hora'] ?? '').toList() ?? [];
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildReservationList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTimePicker(context),
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildReservationList() {
    final normalizedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final reservations = _reservations[normalizedDate] ?? [];
    
    if (reservations.isEmpty) {
      return const Center(
        child: Text(
          'No hay reservas para este día',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    
    // Ordenar por hora
    reservations.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    
    return ListView.builder(
      itemCount: reservations.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fecha: ${reservations[index]['fechaStr']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Hora: ${reservations[index]['hora']}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDeleteReservation(reservations[index]['id']),
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[800]!,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      _addReservation(pickedTime);
    }
  }

  Future<void> _addReservation(TimeOfDay time) async {
    try {
      final hora = _formatTimeOfDay(time);
      final fechaStr = '${_selectedDay.day} de ${_getMonthName(_selectedDay.month)} de ${_selectedDay.year}';
      
      // Creamos DateTime con la hora seleccionada
      final fechaCompleta = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        time.hour,
        time.minute,
      );
      
      // Agregar a Firestore
      await _firestore.collection('reservas').add({
        'fecha': Timestamp.fromDate(fechaCompleta),
        'fechaStr': fechaStr,
        'hora': hora,
        'timestamp': fechaCompleta,
      });
      
      // Actualizar UI
      _loadReservations();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva agregada: $hora')),
      );
    } catch (e) {
      debugPrint('Error adding reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al agregar reserva')),
      );
    }
  }

  Future<void> _confirmDeleteReservation(String docId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Eliminar esta reserva?'),
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
              backgroundColor: Colors.red,
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
        const SnackBar(content: Text('Reserva eliminada')),
      );
    } catch (e) {
      debugPrint('Error deleting reservation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar reserva')),
      );
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'a. m.' : 'p. m.';
    return '$hour:$minute $period';
  }

  String _getMonthName(int month) {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return months[month - 1];
  }
}