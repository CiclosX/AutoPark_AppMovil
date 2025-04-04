import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

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
      _showErrorSnackbar('Error al cargar reservas');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Reservas', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading ? _buildLoadingIndicator(theme) : _buildMainContent(theme),
      floatingActionButton: _buildAddButton(theme),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Center(
      child: CircularProgressIndicator(
        color: theme.primaryColor,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    return Column(
      children: [
        _buildCalendarCard(theme),
        const SizedBox(height: 8),
        Expanded(child: _buildReservationList(theme)),
      ],
    );
  }

  Widget _buildCalendarCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: theme.cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 365)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) => setState(() => _calendarFormat = format),
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
            todayDecoration: BoxDecoration(
              color: theme.primaryColor.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: theme.primaryColor,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            outsideDaysVisible: false,
            defaultTextStyle: theme.textTheme.bodyMedium!,
            weekendTextStyle: theme.textTheme.bodyMedium!,
            holidayTextStyle: theme.textTheme.bodyMedium!,
          ),
          headerStyle: HeaderStyle(
            titleTextStyle: theme.textTheme.titleMedium!,
            formatButtonTextStyle: theme.textTheme.bodyMedium!.copyWith(
              color: theme.primaryColor,
            ),
            formatButtonDecoration: BoxDecoration(
              border: Border.all(color: theme.primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: theme.primaryColor),
            rightChevronIcon: Icon(Icons.chevron_right, color: theme.primaryColor),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            weekendStyle: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          eventLoader: (day) => _reservations[day]?.map((r) => r['hora'] ?? '').toList() ?? [],
        ),
      ),
    );
  }

  Widget _buildReservationList(ThemeData theme) {
    final normalizedDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    final reservations = _reservations[normalizedDate] ?? [];
    
    if (reservations.isEmpty) {
      return Center(
        child: Text(
          'No hay reservas para este día',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
          ),
        ),
      );
    }
    
    reservations.sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: reservations.length,
        itemBuilder: (context, index) => _buildReservationCard(reservations[index], theme),
      ),
    );
  }

  Widget _buildReservationCard(Map<String, dynamic> reservation, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      color: theme.cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha: ${reservation['fechaStr']}',
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Hora: ${reservation['hora']}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red, size: 28),
              onPressed: () => _confirmDeleteReservation(reservation['id'], theme),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _buildAddButton(ThemeData theme) {
    return FloatingActionButton(
      onPressed: () => _showTimePicker(context, theme),
      backgroundColor: theme.primaryColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.add, color: Colors.white, size: 28),
    );
  }

  Future<void> _showTimePicker(BuildContext context, ThemeData theme) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: Colors.white,
              surface: theme.cardTheme.color ?? theme.colorScheme.surface,
            ),
            dialogBackgroundColor: theme.cardTheme.color,
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
      
      final fechaCompleta = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        time.hour,
        time.minute,
      );
      
      await _firestore.collection('reservas').add({
        'fecha': Timestamp.fromDate(fechaCompleta),
        'fechaStr': fechaStr,
        'hora': hora,
        'timestamp': fechaCompleta,
      });
      
      _loadReservations();
      _showSuccessSnackbar('Reserva agregada: $hora');
    } catch (e) {
      debugPrint('Error adding reservation: $e');
      _showErrorSnackbar('Error al agregar reserva');
    }
  }

  Future<void> _confirmDeleteReservation(String docId, ThemeData theme) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirmar eliminación',
          style: theme.textTheme.titleLarge,
        ),
        content: const Text('¿Estás seguro de que deseas eliminar esta reserva?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: theme.cardTheme.color,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteReservation(docId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Eliminar',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteReservation(String docId) async {
    try {
      await _firestore.collection('reservas').doc(docId).delete();
      _loadReservations();
      _showSuccessSnackbar('Reserva eliminada');
    } catch (e) {
      debugPrint('Error deleting reservation: $e');
      _showErrorSnackbar('Error al eliminar reserva');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
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