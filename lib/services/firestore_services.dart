import 'package:autopark_appmovil/models/floor_model.dart';
import 'package:autopark_appmovil/models/tarifa_model.dart';
import 'package:autopark_appmovil/models/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static final FirestoreServices _instance = FirestoreServices._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  factory FirestoreServices() {
    return _instance;
  }

  FirestoreServices._internal();

//Taki taki Rumba
// Función para actualizar el rol de un usuario
  Future<void> updateUserRole(String uid, String newRole) async {
    try {
      await _db.collection('usuarios').doc(uid).update({
        'rol': newRole,
      });
    } catch (e) {
      print("Error al actualizar el rol: $e");
    }
  }

  // Función para obtener todos los usuarios
  Future<List<Usuario>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _db.collection('usuarios').get();
      return snapshot.docs.map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Error al obtener usuarios: $e");
      return [];
    }
  }

  

//Taki taki Rumba

  Stream <List<FloorModel>>obtenerPisos() {
    return _firestore.collection('piso').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => FloorModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  
  Future<void>eliminarPiso(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).delete();
  }

  Future<void> agregarPiso(String collection, Map<String, dynamic> data) {
    return _firestore.collection(collection).add(data);
  }

  Future<void> editarPiso(String collection, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).update(data);
  }

// Métodos CRUD para tarifa
  Stream<List<TarifaModel>> obtenerTarifas() {
    return _firestore.collection('estacionamiento').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TarifaModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<void> agregarTarifa(Map<String, dynamic> data) {
    return _firestore.collection('estacionamiento').add(data);
  }

  Future<void> editarTarifa(String docId, Map<String, dynamic> data) {
    return _firestore.collection('estacionamiento').doc(docId).update(data);
  }

  Future<void> eliminarTarifa(String docId) {
    return _firestore.collection('estacionamiento').doc(docId).delete();
  }

  streamUser(uid) {}

}



