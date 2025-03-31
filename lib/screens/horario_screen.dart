import 'package:flutter/material.dart';
import 'package:autopark_appmovil/services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HorarioScreen extends StatefulWidget {
  final String estacionamientoId;

  const HorarioScreen({
    Key? key,
    required this.estacionamientoId,
  }) : super(key: key);

  @override
  State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
  final FirestoreServices _firestoreServices = FirestoreServices();
  Timestamp? _horarioActual;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _cargarHorario();
  }

  Future<void> _cargarHorario() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final horario = await _firestoreServices.getHorario(widget.estacionamientoId);
      setState(() {
        _horarioActual = horario;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar horario: $e');
      setState(() {
        _isLoading = false;
      });
      _mostrarError('No se pudo cargar el horario');
    }
  }

  Future<void> _guardarHorario() async {
    if (_horarioActual == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await _firestoreServices.updateHorario(widget.estacionamientoId, _horarioActual!);
      setState(() {
        _isSaving = false;
      });
      _mostrarExito('Horario actualizado correctamente');
    } catch (e) {
      print('Error al guardar horario: $e');
      setState(() {
        _isSaving = false;
      });
      _mostrarError('No se pudo guardar el horario');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatDateTime(Timestamp? timestamp) {
    if (timestamp == null) return 'Fecha no disponible';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('d MMMM yyyy, h:mm:ss a').format(dateTime) +
        ' UTC' +
        (dateTime.timeZoneOffset.inHours > 0 ? '+' : '') +
        '${dateTime.timeZoneOffset.inHours}';
  }

  Future<void> _mostrarSelectorFecha() async {
    if (_horarioActual == null) return;

    final DateTime fechaActual = _horarioActual!.toDate();
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (fechaSeleccionada != null) {
      final TimeOfDay? horaSeleccionada = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fechaActual),
      );

      if (horaSeleccionada != null) {
        final DateTime nuevaFechaHora = DateTime(
          fechaSeleccionada.year,
          fechaSeleccionada.month,
          fechaSeleccionada.day,
          horaSeleccionada.hour,
          horaSeleccionada.minute,
        );

        setState(() {
          _horarioActual = Timestamp.fromDate(nuevaFechaHora);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'El horario actual es',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _formatDateTime(_horarioActual),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  _formatDateTime(_horarioActual),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: _mostrarSelectorFecha,
                              child: const Text(
                                'Cambiar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _guardarHorario,
          icon: _isSaving
              ? Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(Icons.save, color: Colors.white),
          label: Text(
            _isSaving ? 'Guardando...' : 'Guardar Horario',
            style: const TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}