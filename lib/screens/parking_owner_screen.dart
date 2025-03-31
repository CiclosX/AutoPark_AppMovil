import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_screen.dart';

class ParkingOverviewScreen extends StatefulWidget {
  const ParkingOverviewScreen({super.key});

  @override
  _ParkingOverviewScreenState createState() => _ParkingOverviewScreenState();
}

class _ParkingOverviewScreenState extends State<ParkingOverviewScreen> {
  List<Map<String, dynamic>> espacios = [
    {'id': 'espacio_1', 'nombre': 'Espacio 1', 'cajones': 15, 'color': Colors.blue},
    {'id': 'espacio_2', 'nombre': 'Espacio 2', 'cajones': 10, 'color': Colors.blue},
    {'id': 'espacio_3', 'nombre': 'Espacio 3', 'cajones': 8, 'color': Colors.blue},
  ];

  void _agregarEspacio() {
    TextEditingController nombreController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Espacio"),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(hintText: "Nombre del espacio"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  espacios.add({
                    'id': 'espacio_${espacios.length + 1}',
                    'nombre': nombreController.text.isNotEmpty ? nombreController.text : 'Espacio ${espacios.length + 1}',
                    'cajones': 5,
                    'color': Colors.blue,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  void _editarEspacio(int index) {
    TextEditingController nombreController = TextEditingController(text: espacios[index]['nombre']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Espacio"),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(hintText: "Nuevo nombre del espacio"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  espacios[index]['nombre'] = nombreController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _eliminarEspacio(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar este espacio?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  espacios.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lugares',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _agregarEspacio,
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(espacios.length, (index) {
            return _buildCard(
              context: context,
              index: index,
              title: ' ${espacios[index]['nombre']}',
              subtitle: 'Ver más detalles',
              icon: Icons.local_parking,
              color: espacios[index]['color'],
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingScreen(
                      espacioId: espacios[index]['id'],
                      espacioNombre: espacios[index]['nombre'],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }


  Widget _buildCard({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarEspacio(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarEspacio(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
