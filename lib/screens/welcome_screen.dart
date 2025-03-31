import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final String userName;
  
  const WelcomeScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              'assets/images/parking_cars.jpg', // Reemplaza con tu propia imagen
              fit: BoxFit.cover,
      body: Container(
        // Fondo con imagen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/carro.jpg'), // Ruta de la imagen
            fit: BoxFit.cover, // Ajusta la imagen para cubrir toda la pantalla
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment
                  .end, // Alinea el contenido en la parte inferior
              children: [
                // Rectángulo con color RGB (255, 0, 123, 255)
                Container(
                  width: MediaQuery.of(context).size.width * 1.2,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 0, 123, 255), // Color RGB (255, 0, 123, 255)
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Sombra para dar profundidad
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .max, // Ajusta el tamaño de la columna al contenido
                    children: [
                      // Título "Bienvenido Usuario"
                      Text(
                        'Bienvenido Usuario',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Nombre de usuario "Juanito"
                      Text(
                        'Juanito',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Botón "Entrar"
                      ElevatedButton(
                        onPressed: () {
                          // Navega a la pantalla HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                  color: Colors.blue,
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
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_parking,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
              
              // Mensaje de bienvenida
              const SizedBox(height: 24),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Nombre de usuario
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              // Espacio antes del botón
              const SizedBox(height: 50),
              
              // Botón de entrar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navegación a la siguiente pantalla
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
            ),
          ),
      ),],
      ),
    );
  }
}

// Clase para crear la forma de onda en la parte superior del contenedor azul
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
    final secondEndPoint = Offset(0, 0);
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