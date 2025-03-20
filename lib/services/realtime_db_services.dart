import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDbService {
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://autopark-2a8b9-default-rtdb.firebaseio.com',
  ).ref("estacionamiento");

  Stream<Map<String, dynamic>> getEstadoEspacio(String espacioId) {
    return _dbRef.child(espacioId).onValue.map((event) {
      final data = event.snapshot.value;

      if (data == null) {
        print("⚠️ No se encontraron datos en Firebase.");
        return {'estado': 'desconocido', 'timestamp': 0};
      }

      if (data is Map<dynamic, dynamic>) {
        print("✅ Datos recibidos: $data");
        return {
          'estado': data['estado'] ?? 'desconocido',
          'timestamp': data['timestamp'] ?? 0,
        };
      } else {
        print("⚠️ Formato inesperado: $data");
        return {'estado': 'desconocido', 'timestamp': 0};
      }
    });
  }
}
