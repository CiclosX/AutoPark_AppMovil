import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/screens/register_screen.dart'; // Asegúrate de importar RegisterScreen
import 'package:autopark_appmovil/services/auth_services.dart';

class SigninScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Hola',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              // Campo de Email
              const Text(
                'Usuario',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, 
                    horizontal: 16
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              // Campo de Contraseña
              const Text(
                'Contraseña',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Ingresa tu contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16, 
                    horizontal: 16
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 8),
              // Enlace "Olvidaste tu contraseña?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _showForgotPasswordDialog(context),
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botón de Entrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _signInWithEmail(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botón de Google
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _signInWithGoogle(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Image.asset(
                    'assets/img/google-logo.png',
                    width: 24,
                    height: 24,
                  ),
                  label: const Text(
                    'Continuar con Google',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Enlace para crear cuenta
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: 'No tienes cuenta? ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Crea una',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithEmail(BuildContext context) async {
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor completa todos los campos')),
        );
        return;
      }

      final credenciales = await _authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      
      if (credenciales != null && credenciales.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final credenciales = await _authService.signInWithGoogle();
      if (credenciales.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión con Google: ${e.toString()}')),
      );
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recuperar contraseña'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(
            hintText: 'Ingresa tu email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor ingresa tu email')),
                );
                return;
              }
              
              try {
                await _authService.sendPasswordResetEmail(emailController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email de recuperación enviado. Revisa tu bandeja de entrada.'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')),
                );
              }
            },
            child: const Text('Enviar'),
          ),
        ],
      ),
    );
  }
}