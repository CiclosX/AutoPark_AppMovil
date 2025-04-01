import 'package:autopark_appmovil/models/floor_model.dart';
import 'package:autopark_appmovil/models/tarifa_model.dart';
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

}



