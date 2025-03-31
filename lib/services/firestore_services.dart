import 'package:autopark_appmovil/models/estacionamiento_model.dart';
import 'package:autopark_appmovil/models/floor_model.dart';
import 'package:autopark_appmovil/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static final FirestoreServices _instance = FirestoreServices._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  factory FirestoreServices() {
    return _instance;
  }

  FirestoreServices._internal();

  Stream<List<UserModel>> getUser(String collection) {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => UserModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

  Future<void> addUser(String collection, Map<String, dynamic> data) {
    return _firestore.collection(collection).add(data);
  }

  Future<void> updateUser(
      String collection, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).update(data);
  }

  Future<void> deleteUser(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).delete();
  }

//Taki taki Rumba
// Para obtener todos los estacionamientos
  Stream<List<EstacionamientoModel>> getEstacionamientos() {
    return _firestore.collection('estacionamiento').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => EstacionamientoModel.fromDocumentSnapshot(doc))
          .toList();
    });
  }

// Para obtener un estacionamiento específico
  Future<EstacionamientoModel> getEstacionamiento(String docId) async {
    final doc = await _firestore.collection('estacionamiento').doc(docId).get();
    return EstacionamientoModel.fromDocumentSnapshot(doc);
  }

// Para agregar un nuevo estacionamiento
  Future<void> addEstacionamiento(Map<String, dynamic> data) {
    return _firestore.collection('estacionamiento').add(data);
  }

// Para actualizar un estacionamiento existente
  Future<void> updateEstacionamiento(String docId, Map<String, dynamic> data) {
    return _firestore.collection('estacionamiento').doc(docId).update(data);
  }

// Para eliminar un estacionamiento
  Future<void> deleteEstacionamiento(String docId) {
    return _firestore.collection('estacionamiento').doc(docId).delete();
  }

// Métodos específicos para cada campo
  Future<int> getCapacidad(String estacionamientoId) async {
    final doc = await _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .get();
    return doc.data()?['capacidad'] ?? 0;
  }

  Future<void> updateCapacidad(String estacionamientoId, int capacidad) {
    return _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .update({'capacidad': capacidad});
  }

  Future<Timestamp> getHorario(String estacionamientoId) async {
    final doc = await _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .get();
    return doc.data()?['horario'] ?? Timestamp.now();
  }

  Future<void> updateHorario(String estacionamientoId, Timestamp horario) {
    return _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .update({'horario': horario});
  }

  Future<double> getTarifaActual(String estacionamientoId) async {
    final doc = await _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .get();
    return (doc.data()?['tarifa'] ?? 0.0).toDouble();
  }

  Future<void> updateTarifa(String estacionamientoId, double tarifa) {
    return _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .update({'tarifa': tarifa});
  }

  Future<String> getUbicacion(String estacionamientoId) async {
    final doc = await _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .get();
    return doc.data()?['ubicacion'] ?? "";
  }

  Future<void> updateUbicacion(String estacionamientoId, String ubicacion) {
    return _firestore
        .collection('estacionamiento')
        .doc(estacionamientoId)
        .update({'ubicacion': ubicacion});
  }


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


}



