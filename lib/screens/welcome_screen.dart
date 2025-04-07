import 'package:autopark_appmovil/screens/auth_screen.dart';
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
        fit: StackFit.expand,
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/img/fondito.jpg',
              fit: BoxFit.cover,
              color: isDark ? Colors.black.withOpacity(0.5) : null,
              colorBlendMode: isDark ? BlendMode.darken : BlendMode.dstIn,
            ),
          ),

          // Curva azul en la parte superior
// Curva azul en la parte inferior con forma superior
Positioned(
  top: MediaQuery.of(context).size.height * 0.3,
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


          // Contenido principal
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Espacio para dejar la curva arriba
              SizedBox(height: MediaQuery.of(context).size.height * 0.35),

              // Logo
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
                      width: 2,
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

              const SizedBox(height: 24),

              // Texto de bienvenida
              Text(
                'Bienvenido',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (userName.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],

              const SizedBox(height: 50),

              // Botón de entrar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthScreen()),
                    );
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

              const SizedBox(height: 20),

              // Botón de cambio de tema
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

// Curva superior personalizada
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0); // Esquina superior izquierda

    // Curva hacia abajo en la parte superior
    path.quadraticBezierTo(
      size.width / 2, size.height * 0.5, // Punto de control (centro abajo)
      size.width, 0, // Termina arriba derecha
    );

    // Lados y parte inferior
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
