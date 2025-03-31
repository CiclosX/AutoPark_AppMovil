
import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienbenido a la aplicacion mascotas'),
            ElevatedButton.icon(
              onPressed: ()async{
                final credenciales = await _authService.singInWithGoogle();
                print('usuario: ${credenciales.user?.displayName}');
                print('email: ${credenciales.user?.email}');
                //si todo sale bien redirigir a la pantalla de mascotas
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
              icon: const Icon(Icons.login),
              label: const Text('Iniciar sesion con Google')
            )
          ],
        ),
      ),
    );
  }
}