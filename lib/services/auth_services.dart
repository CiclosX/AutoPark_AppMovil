import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --------------------------
  // 1. Registro de Usuarios
  // --------------------------
  Future<UserCredential?> registerUserWithVehicle({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String userType,
    required String vehiclePlate,
    required String vehicleBrand,
    required String vehicleModel,
    required String vehicleColor,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      final UserCredential userCredential = 
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userId = userCredential.user!.uid;
        
        // Guardar usuario en colección 'usuarios'
        await _saveUserData(
          userId: userId,
          email: email,
          name: name,
          phone: phone,
          userType: userType,
        );

        // Guardar vehículo en colección 'vehículos'
        await _saveVehicleData(
          userId: userId,
          email: email,
          plate: vehiclePlate,
          brand: vehicleBrand,
          model: vehicleModel,
          color: vehicleColor,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    } catch (e) {
      throw Exception('Error desconocido durante el registro: $e');
    }
  }

  Future<void> _saveUserData({
    required String userId,
    required String email,
    required String name,
    required String phone,
    required String userType,
  }) async {
    await _firestore.collection('usuarios').doc(userId).set({
      'correo': email,
      'nombre': name,
      'teléfono': phone,
      'tipo': userType,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _saveVehicleData({
    required String userId,
    required String email,
    required String plate,
    required String brand,
    required String model,
    required String color,
  }) async {
    await _firestore.collection('vehículos').doc().set({
      'usuarioId': userId,
      'correo': email,
      'placa': plate,
      'marca': brand,
      'modelo': model,
      'color': color,
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  // --------------------------
  // 2. Inicio de Sesión
  // --------------------------
  Future<UserCredential?> signInWithEmailAndPassword(
    String email, 
    String password,
  ) async {
    try {
      final UserCredential userCredential = 
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // --------------------------
  // 3. Autenticación con Google
  // --------------------------
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = 
          await googleUser?.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential = 
          await _firebaseAuth.signInWithCredential(credential);

      // Si es nuevo usuario, guardar datos en Firestore
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await _saveUserData(
          userId: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'Usuario Google',
          phone: userCredential.user!.phoneNumber ?? '',
          userType: 'Usuario', // Por defecto para usuarios de Google
        );
      }

      return userCredential;
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }

  // --------------------------
  // 4. Recuperación de Contraseña
  // --------------------------
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  // --------------------------
  // 5. Cerrar Sesión
  // --------------------------
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await GoogleSignIn().signOut(); // Cerrar también sesión de Google si existe
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  // --------------------------
  // 6. Obtener Usuario Actual
  // --------------------------
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // --------------------------
  // 7. Obtener Datos del Usuario desde Firestore
  // --------------------------
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('usuarios').doc(userId).get();
      if (doc.exists) {
        return doc.data()!;
      }
      throw Exception('Usuario no encontrado en la base de datos');
    } catch (e) {
      throw Exception('Error al obtener datos del usuario: $e');
    }
  }

  // --------------------------
  // 8. Obtener Vehículos del Usuario
  // --------------------------
  Future<List<Map<String, dynamic>>> getUserVehicles(String userId) async {
    try {
      final query = await _firestore
          .collection('vehículos')
          .where('usuarioId', isEqualTo: userId)
          .get();
      
      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception('Error al obtener vehículos del usuario: $e');
    }
  }

  // --------------------------
  // 9. Manejo de Errores
  // --------------------------
  Exception _handleAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return Exception('El correo ya está registrado');
      case 'invalid-email':
        return Exception('Correo electrónico inválido');
      case 'operation-not-allowed':
        return Exception('Operación no permitida');
      case 'weak-password':
        return Exception('Contraseña débil (mínimo 6 caracteres)');
      case 'user-disabled':
        return Exception('Usuario deshabilitado');
      case 'user-not-found':
        return Exception('Usuario no encontrado');
      case 'wrong-password':
        return Exception('Contraseña incorrecta');
      case 'too-many-requests':
        return Exception('Demasiados intentos. Intenta más tarde');
      default:
        return Exception('Error de autenticación: $code');
    }
  }

  // --------------------------
  // 10. Verificar si el email está verificado
  // --------------------------
  Future<bool> isEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  // --------------------------
  // 11. Enviar email de verificación
  // --------------------------
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }
}