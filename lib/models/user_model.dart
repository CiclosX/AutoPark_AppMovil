import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String id;
  final String nombre;
  final String correo;
  final int telefono;
  final String tipo;



  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
    required this.tipo});

  //convertir de un usermodel a un map
  //cuando se inserta un usuario desde la app
Map<String, dynamic> toMap(){
  return {
    'nombre': nombre,
    'telefono': telefono,
    'correo': correo,
    'tipo': tipo,
  };
}

  //convertir de un DocumentSnapshot a un petmodel
  //cuando se obtiene una mascota desde la base de datos
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc){
    return UserModel(
      id: doc.id,
      nombre: doc['nombre'],
      telefono: doc['telefono'] as int,
      correo: doc['correo'],
      tipo: doc['tipo'],
    );
  }
}