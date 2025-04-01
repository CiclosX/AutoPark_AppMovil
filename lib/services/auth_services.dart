import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
}