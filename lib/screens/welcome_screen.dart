import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;

  const WelcomeScreen({
    super.key,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final waveColor = isDark ? Colors.blue[900]! : Colors.blue;

    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo superior (coches estacionados)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.asset(
              'assets/img/fondito.jpg',
              fit: BoxFit.cover,
              color: isDark ? Colors.black.withOpacity(0.5) : null,
              colorBlendMode: isDark ? BlendMode.darken : BlendMode.dstIn,
            ),
          ),

          // Contenedor con forma de onda azul
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: waveColor,
                ),
              ),
            ),
          ),

          // Contenido principal (logo, texto y botón)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Espacio para que el contenido caiga debajo de la imagen
              SizedBox(height: MediaQuery.of(context).size.height * 0.35),

              // Logo de estacionamiento
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.blue[800] : Colors.blue[700],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? Colors.blue[200]! : Colors.white, 
                      width: 2
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_parking,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ),

              // Mensaje de bienvenida
              const SizedBox(height: 24),
              Text(
                'Bienvenido',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Nombre de usuario (si lo necesitas)
              if (userName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],

              // Espacio antes del botón
              const SizedBox(height: 50),

              // Botón de entrar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isDark ? Colors.blue[900] : Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Entrar',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Botón para cambiar tema (opcional)
              const SizedBox(height: 20),
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  themeProvider.toggleTheme(!isDark);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Clase para crear la forma de onda (sin cambios)
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    // Creando la forma de onda
    final firstControlPoint = Offset(size.width * 0.7, size.height * 0.15);
    final firstEndPoint = Offset(size.width * 0.5, size.height * 0.2);
    path.quadraticBezierTo(
      firstControlPoint.dx, 
      firstControlPoint.dy,
      firstEndPoint.dx, 
      firstEndPoint.dy
    );

    final secondControlPoint = Offset(size.width * 0.3, size.height * 0.25);
    const secondEndPoint = Offset(0, 0);
    path.quadraticBezierTo(
      secondControlPoint.dx, 
      secondControlPoint.dy, 
      secondEndPoint.dx, 
      secondEndPoint.dy
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}