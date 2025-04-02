import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  //TakiTakiRumba

  // Obtener el ID Token
  Future<String?> getIdToken() async {
    User? user = _firebaseAuth.currentUser;
    return await user?.getIdToken();
  }

  // Obtener lista de usuarios
  Future<void> fetchUsers() async {
    String apiKey =
        "AIzaSyATp65txvxEOTgyW-RRJ_rHJwM49a_U3R4"; // 🔹 Reemplaza con tu API Key de Firebase
    String endpoint =
        "https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$apiKey";

    String? idToken = await getIdToken();
    if (idToken == null) {
      print("⚠️ No se pudo obtener el token del usuario.");
      return;
    }

    var response = await http.post(
      Uri.parse(endpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"idToken": idToken}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("✅ Usuarios obtenidos: $data");
    } else {
      print("❌ Error al obtener usuarios: ${response.body}");
    }
  }
  //TakiTakiRumba

  // Iniciar sesión con Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // 1. Mostrar el selector de cuentas
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('No se seleccionó ninguna cuenta');
      }

      // 2. Obtener los detalles de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Crear credenciales
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Iniciar sesión en Firebase
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print('Error en Google Sign-In: $e');
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Cerrar sesión en Google
    await _firebaseAuth.signOut(); // Cerrar sesión en Firebase
  }

  // Método para email/contraseña (opcional)
  Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      return null;
    }
  }
  //TakiTaki
  // Obtener el ID Token del usuario autenticado
}
