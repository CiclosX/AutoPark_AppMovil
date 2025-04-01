import 'package:cloud_firestore/cloud_firestore.dart';

class Estacionamiento {
  final String? id;
  final String nombre;
  final int capacidad;
  final double tarifa;
  final String ubicacion;

  Estacionamiento({
    this.id,
    required this.nombre,
    required this.capacidad,
    required this.tarifa,
    required this.ubicacion,
  });

  factory Estacionamiento.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Estacionamiento(
      id: doc.id,
      nombre: data['nombre'] ?? 'Sin nombre',
      capacidad: (data['capacidad'] ?? 0).toInt(),
      tarifa: (data['tarifa'] ?? 0).toDouble(),
      ubicacion: data['ubicacion'] ?? 'Sin ubicación',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'capacidad': capacidad,
      'tarifa': tarifa,
      'ubicacion': ubicacion,
    };
  }
}