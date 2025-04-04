// usuario.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String foto;
  final String rol;
  final Timestamp? creadoEn;

  Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    required this.foto,
    required this.rol,
    this.creadoEn,
  });

  // Convertir un `Usuario` en un Mapa (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nombre': nombre,
      'email': email,
      'foto': foto,
      'rol': rol,
      'creadoEn': creadoEn ?? FieldValue.serverTimestamp(),
    };
  }

  // Crear un `Usuario` desde un documento de Firestore
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] ?? '',
      nombre: map['nombre'] ?? 'Sin nombre',
      email: map['email'] ?? '',
      foto: map['foto'] ?? '',
      rol: map['rol'] ?? 'usuario',
      creadoEn: map['creadoEn'],
    );
  }
}
