import 'package:flutter/material.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String pisoNombre;

  const NoDataFoundScreen({super.key, required this.pisoNombre});

  @override
  Widget build(BuildContext context) {
    TextEditingController lugarController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos no encontrados', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron lugares disponibles para el $pisoNombre.',
              style: const TextStyle(fontSize: 20, color: Colors.black), // Cambié el color a blanco
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Aquí se abre un cuadro de diálogo para agregar lugares
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Agregar Lugar"),
                      content: TextField(
                        controller: lugarController,
                        decoration: const InputDecoration(hintText: "Nombre del lugar"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Lógica para agregar un lugar
                            if (lugarController.text.isNotEmpty) {
                              // Puedes agregar la lógica de almacenamiento aquí
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lugar ${lugarController.text} agregado.')),
                              );
                              Navigator.pop(context); // Cerrar el cuadro de diálogo después de agregar
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Por favor, ingresa un nombre para el lugar.')),
                              );
                            }
                          },
                          child: const Text("Agregar"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Agregar Lugares"),
            ),
          ],
        ),
      ),
    );
  }
}
