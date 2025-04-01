import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hola',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Usuario',
                hintText: 'Enter email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Enter password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Acción para "Olvidaste tu contraseña?"
              },
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción para "Entrar"
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Acción para "Crea una"
              },
              child: RichText(
                text: const TextSpan(
                  text: '¿No tienes cuenta? ',
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
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
          ],
        ),
      ),
    );
  }
}