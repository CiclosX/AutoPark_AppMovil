import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/services/auth_services.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final AuthService _authService = AuthService();
  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo de la aplicación
              Image.asset(
                'assets/img/logo.jpg',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 30),
              
              // Mensaje de bienvenida
              const Text(
                '¡Bienvenido a Autopark!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Encuentra tu lugar, sin complicaciones',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Botón de Google mejorado
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _termsAccepted 
                      ? () => _signInWithGoogle(context)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[200],
                    disabledForegroundColor: Colors.grey,
                  ),
                  icon: Image.asset(
                    'assets/img/google-logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    'Iniciar sesión con Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Checkbox de términos y condiciones
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _termsAccepted,
                    onChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => _showTermsDialog(context),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          children: [
                            TextSpan(text: 'Acepto los '),
                            TextSpan(
                              text: 'Términos y Condiciones',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' y la '),
                            TextSpan(
                              text: 'Política de Privacidad',
                              style: TextStyle(
                                color: Colors.blue,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos y condiciones primero'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credenciales = await _authService.signInWithGoogle();
      
      if (credenciales.user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
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
              setState(() => _termsAccepted = true);
              Navigator.pop(context);
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}