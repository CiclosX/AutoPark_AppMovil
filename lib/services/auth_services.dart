import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autopark_appmovil/models/usuario.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Registro con email y contraseña
  Future<String?> signUp(String email, String password, String rol) async {
    try {
      // Crear usuario en Firebase Authentication
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener UID
      String uid = userCredential.user!.uid;

      // Crear un objeto Usuario
      Usuario usuario = Usuario(
        uid: uid,
        nombre: email.split('@')[0], // Usamos el nombre de usuario como ejemplo
        email: email,
        foto: '', // Podrías añadir una foto si es necesario
        rol: rol, // Asignamos el rol (usuario o admin)
      );

      // Guardar usuario en Firestore
      await _firestore.collection("usuarios").doc(uid).set(usuario.toMap());

      return null; // Sin errores
    } catch (e) {
      return e.toString(); // Devuelve el error si ocurre
    }
  }

  // Inicio de sesión con email y contraseña
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Sin errores
    } catch (e) {
      return e.toString(); // Devuelve el error si ocurre
    }
  }

  // Obtener el estado actual del usuario
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  // Guardar datos del usuario en Firestore
  Future<void> saveUserData(User user) async {
  DocumentReference docRef = _firestore.collection("usuarios").doc(user.uid);
  DocumentSnapshot doc = await docRef.get();

  String rol = 'usuario';
  if (doc.exists) {
    rol = (doc.data() as Map<String, dynamic>)['rol'] ?? 'usuario';
  }

  Usuario usuario = Usuario(
    uid: user.uid,
    nombre: user.displayName ?? 'Sin nombre',
    email: user.email ?? 'No proporcionado',
    foto: user.photoURL ?? '',
    rol: rol,
  );

  await docRef.set(usuario.toMap(), SetOptions(merge: true));
}


  // Obtener usuario actual desde Firestore
  Future<Usuario?> get currentUser async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection("usuarios").doc(user.uid).get();
    if (!doc.exists) return null;

    return Usuario.fromMap(doc.data()!);
  }

  // Verificar si el usuario tiene un vehículo registrado
  Future<bool> tieneVehiculoRegistrado(String uid) async {
    final vehiculos = await _firestore
        .collection("vehiculos")
        .where("usuarioId", isEqualTo: uid)
        .get();
    return vehiculos.docs.isNotEmpty;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
