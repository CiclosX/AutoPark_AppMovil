import 'package:cloud_firestore/cloud_firestore.dart';

class TarifaModel {
  final String id;
  final double tarifa;

  TarifaModel({
    required this.id,
    required this.tarifa,
  });

  // Convertir de un TarifaModel a un Map
  Map<String, dynamic> toMap() {
    return {
      'tarifa': tarifa,
    };
  }

  // Convertir de un DocumentSnapshot a un TarifaModel
  factory TarifaModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return TarifaModel(
      id: doc.id,
      tarifa: (doc['tarifa'] as num).toDouble(),
    );
  }
}
