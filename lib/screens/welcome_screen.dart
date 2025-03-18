import 'package:flutter/material.dart';
import 'home_screens.dart'; // Importa la pantalla principal

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fondo con imagen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/carro.jpg'), // Ruta de la imagen
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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(
                        255, 0, 123, 255), // Color RGB (255, 0, 123, 255)
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.3), // Sombra para dar profundidad
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
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
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

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
                              color: Colors.black.withOpacity(0.5),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Botón "Entrar"
                      ElevatedButton(
                        onPressed: () {
                          // Navega a la pantalla HomeScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
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
        ),
      ),
    );
  }
}
