import 'package:cloud_firestore/cloud_firestore.dart';

class FloorModel {
  final String id;
  final String nombre;

  FloorModel({
    required this.id,
    required this.nombre,
  });

  // Convertir de un FloorModel a un Map
  // Cuando se inserta un piso desde la app
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }

  // Convertir de un DocumentSnapshot a un FloorModel
  // Cuando se obtiene un piso desde la base de datos
  factory FloorModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return FloorModel(
      id: doc.id,
      nombre: doc['nombre'],
    );
  }
}