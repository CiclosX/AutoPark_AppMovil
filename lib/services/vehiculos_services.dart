import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VehiculoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registra un vehículo y lo asocia al usuario autenticado
  Future<void> registrarVehiculo(
    String color,
    String marca,
    String modelo,
    String placa,
  ) async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("No hay usuario autenticado.");
      }

      await _firestore.collection("vehiculos").add({
        "usuarioId": usuario.uid, // Relacionamos el vehículo con el usuario
        "color": color,
        "marca": marca,
        "modelo": modelo,
        "placa": placa,
        "fechaRegistro": FieldValue.serverTimestamp(),
      });

      print("✅ Vehículo registrado con éxito.");
    } catch (e) {
      print("❌ Error al registrar vehículo: $e");
      throw Exception("Error al registrar el vehículo.");
    }
  }

  /// Obtiene todos los vehículos del usuario autenticado
  Future<List<Map<String, dynamic>>> obtenerVehiculosUsuario() async {
    try {
      User? usuario = _auth.currentUser;
      if (usuario == null) {
        throw Exception("No hay usuario autenticado.");
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection("vehiculos")
          .where("usuarioId", isEqualTo: usuario.uid)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                "id": doc.id, // Guardamos el ID del documento
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();
    } catch (e) {
      print("❌ Error al obtener vehículos: $e");
      throw Exception("Error al obtener los vehículos.");
    }
  }

  Future<void> editarVehiculo(
    String vehiculoId,
    String color,
    String marca,
    String modelo,
    String placa,
  ) async {
    try {
      await _firestore.collection("vehiculos").doc(vehiculoId).update({
        "color": color,
        "marca": marca,
        "modelo": modelo,
        "placa": placa,
      });

      print("✅ Vehículo actualizado correctamente.");
    } catch (e) {
      print("❌ Error al actualizar vehículo: $e");
    }
  }

  /// Elimina un vehículo por ID
  Future<void> eliminarVehiculo(String vehiculoId) async {
    try {
      await _firestore.collection("vehiculos").doc(vehiculoId).delete();
      print("✅ Vehículo eliminado correctamente.");
    } catch (e) {
      print("❌ Error al eliminar vehículo: $e");
      throw Exception("Error al eliminar el vehículo.");
    }
  }
}
