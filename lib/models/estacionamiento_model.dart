// estacionamiento_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class EstacionamientoModel {
  final String id;
  final int capacidad;
  final Timestamp horario;
  final double tarifa;
  final String ubicacion;

  EstacionamientoModel({
    required this.id,
    required this.capacidad,
    required this.horario,
    required this.tarifa,
    required this.ubicacion,
  });

  factory EstacionamientoModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return EstacionamientoModel(
      id: doc.id,
      capacidad: data['capacidad'] ?? 0,
      horario: data['horario'] ?? Timestamp.now(),
      tarifa: (data['tarifa'] ?? 0.0).toDouble(),
      ubicacion: data['ubicacion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'capacidad': capacidad,
      'horario': horario,
      'tarifa': tarifa,
      'ubicacion': ubicacion,
    };
  }
}