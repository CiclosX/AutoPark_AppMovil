import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autopark_appmovil/screens/registro_vehiculo_screen.dart'; // IMPORTANTE: Asegúrate de importar la pantalla
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String _errorMessage = '';
  bool _isSignIn = true; // Alternar entre login y registro

  void _navigateToRegistroVehiculo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegistroVehiculoScreen()),
    );
  }

  /// **Inicio de sesión**
  void _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa ambos campos.';
      });
      return;
    }

    String? error = await _authService.signInWithEmail(email, password);
    if (error == null) {
      _navigateToRegistroVehiculo(); // ✅ Redirige a la pantalla de registro de vehículo
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  /// **Registro de usuario**
  void _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa ambos campos.';
      });
      return;
    }

    String? error = await _authService.signUp(email, password, 'usuario');
    if (error == null) {
      _navigateToRegistroVehiculo(); // ✅ Redirige a la pantalla de registro de vehículo
    } else {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  /// **Inicio de sesión con Google**
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return; // Si el usuario cancela el login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _authService.saveUserData(user);

        // 🔍 Verificar si el usuario ya tiene un vehículo registrado
        final QuerySnapshot vehiculosSnapshot = await FirebaseFirestore.instance
            .collection("vehiculos")
            .where("usuarioId", isEqualTo: user.uid)
            .get();

        if (vehiculosSnapshot.docs.isEmpty) {
          // 🚗 No tiene vehículos → Enviar a RegistroVehiculoScreen
          _navigateToRegistroVehiculo();
        } else {
          // ✅ Ya tiene un vehículo → Enviar a la pantalla principal
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al iniciar sesión con Google: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Autenticación',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Correo Electrónico',
                hintText: 'Ingresa tu correo electrónico',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Ingresa tu contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSignIn ? _signIn : _signUp,
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: Text(_isSignIn ? 'Iniciar Sesión' : 'Crear Cuenta'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignIn = !_isSignIn;
                  _errorMessage = '';
                });
              },
              child: Text(
                _isSignIn ? '¿No tienes cuenta? Crea una' : '¿Ya tienes cuenta? Inicia sesión',
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _signInWithGoogle,
              icon: const Icon(Icons.login),
              label: const Text('Iniciar sesión con Google'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
