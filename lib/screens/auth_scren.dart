import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autopark_appmovil/screens/registro_vehiculo_screen.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

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
  bool _isSignIn = true;
  bool _termsAccepted = false;
  bool _isLoading = false;

  void _navigateToRegistroVehiculo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegistroVehiculoScreen()),
    );
  }

  void _signIn() async {
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'Debes aceptar los términos y condiciones primero');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingresa ambos campos.');
      return;
    }

    setState(() => _isLoading = true);
    
    String? error = await _authService.signInWithEmail(email, password);
    
    setState(() => _isLoading = false);
    
    if (error == null) {
      _navigateToRegistroVehiculo();
    } else {
      setState(() => _errorMessage = error);
    }
  }

  void _signUp() async {
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'Debes aceptar los términos y condiciones primero');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, ingresa ambos campos.');
      return;
    }

    setState(() => _isLoading = true);
    
    String? error = await _authService.signUp(email, password, 'usuario');
    
    setState(() => _isLoading = false);
    
    if (error == null) {
      _navigateToRegistroVehiculo();
    } else {
      setState(() => _errorMessage = error);
    }
  }

  Future<void> _signInWithGoogle() async {
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'Debes aceptar los términos y condiciones primero');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        await _authService.saveUserData(user);

        final QuerySnapshot vehiculosSnapshot = await FirebaseFirestore.instance
            .collection("vehiculos")
            .where("usuarioId", isEqualTo: user.uid)
            .get();

        setState(() => _isLoading = false);

        if (vehiculosSnapshot.docs.isEmpty) {
          _navigateToRegistroVehiculo();
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al iniciar sesión con Google: $e';
      });
    }
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Por favor, lee atentamente nuestros términos y condiciones:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '1. Al usar Autopark, aceptas cumplir con estas condiciones.\n'
                '2. Debes ser mayor de edad para utilizar nuestros servicios.\n'
                '3. Nos reservamos el derecho de modificar estos términos en cualquier momento.\n'
                '4. Tu información personal será protegida según nuestra política de privacidad.\n'
                '5. El uso indebido de la aplicación puede resultar en la suspensión de tu cuenta.',
              ),
              SizedBox(height: 16),
              Text(
                'Política de Privacidad:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Respetamos tu privacidad. Los datos personales que nos proporciones serán utilizados únicamente para los fines establecidos en nuestra política y no serán compartidos con terceros sin tu consentimiento.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _termsAccepted = true);
            },
            child: const Text('Aceptar'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Autenticación', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
            onPressed: () => themeProvider.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.primaryColor,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.account_circle, 
                              color: theme.primaryColor, 
                              size: 60),
                          const SizedBox(height: 20),
                          Text(
                            _isSignIn ? 'Iniciar Sesión' : 'Crear Cuenta',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : null),
                              hintText: 'Ingresa tu correo electrónico',
                              hintStyle: TextStyle(
                                color: isDarkMode ? Colors.grey[500] : null),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: Icon(Icons.email, 
                                  color: theme.primaryColor),
                              filled: isDarkMode,
                              fillColor: isDarkMode ? Colors.grey[700] : null,
                            ),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : null),
                              hintText: 'Ingresa tu contraseña',
                              hintStyle: TextStyle(
                                color: isDarkMode ? Colors.grey[500] : null),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              prefixIcon: Icon(Icons.lock, 
                                  color: theme.primaryColor),
                              filled: isDarkMode,
                              fillColor: isDarkMode ? Colors.grey[700] : null,
                            ),
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          if (_errorMessage.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.red[900] : Colors.red[50],
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: isDarkMode ? Colors.red[800]! : Colors.red[200]!),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, 
                                      color: isDarkMode ? Colors.red[200] : Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _errorMessage,
                                      style: TextStyle(
                                        color: isDarkMode ? Colors.red[200] : Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: isDarkMode ? Colors.grey[400] : null,
                                ),
                                child: Checkbox(
                                  value: _termsAccepted,
                                  onChanged: (value) {
                                    setState(() => _termsAccepted = value ?? false);
                                  },
                                  activeColor: theme.primaryColor,
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: _showTermsDialog,
                                  child: RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                                      ),
                                      children: [
                                        TextSpan(text: 'Acepto los '),
                                        TextSpan(
                                          text: 'Términos y Condiciones',
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                        TextSpan(text: ' y la '),
                                        TextSpan(
                                          text: 'Política de Privacidad',
                                          style: TextStyle(
                                            color: theme.primaryColor,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isSignIn ? _signIn : _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(_isSignIn ? 'Iniciar Sesión' : 'Crear Cuenta'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isSignIn = !_isSignIn;
                                _errorMessage = '';
                              });
                            },
                            child: Text(
                              _isSignIn ? '¿No tienes cuenta? Crea una' : '¿Ya tienes cuenta? Inicia sesión',
                              style: TextStyle(color: theme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'O continúa con',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _signInWithGoogle,
                            icon: const Icon(Icons.login),
                            label: const Text('Iniciar sesión con Google'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.white,
                              foregroundColor: isDarkMode ? Colors.white : Colors.black,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}