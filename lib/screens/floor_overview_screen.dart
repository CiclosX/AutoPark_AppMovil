import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_owner_screen.dart';
import 'package:autopark_appmovil/screens/no_data_found_screen.dart'; // Agregar la importación de la pantalla NoDataFoundScreen

class FloorOverviewScreen extends StatefulWidget {
  const FloorOverviewScreen({super.key});

  @override
  _FloorOverviewScreenState createState() => _FloorOverviewScreenState();
}

class _FloorOverviewScreenState extends State<FloorOverviewScreen> {
  List<Map<String, dynamic>> pisos = [
    {'id': 'piso_1', 'nombre': 'Piso 1', 'color': Colors.green},
    {'id': 'piso_2', 'nombre': 'Piso 2', 'color': Colors.blue},
    {'id': 'piso_3', 'nombre': 'Piso 3', 'color': Colors.orange},
  ];

  void _agregarPiso() {
    TextEditingController nombreController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Piso"),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(hintText: "Nombre del piso"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pisos.add({
                    'id': 'piso_${pisos.length + 1}',
                    'nombre': nombreController.text.isNotEmpty
                        ? nombreController.text
                        : 'Piso ${pisos.length + 1}',
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

  void _editarPiso(int index) {
    TextEditingController nombreController = TextEditingController(text: pisos[index]['nombre']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Piso"),
          content: TextField(
            controller: nombreController,
            decoration: const InputDecoration(hintText: "Nuevo nombre del piso"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pisos[index]['nombre'] = nombreController.text;
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

  void _eliminarPiso(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar este piso?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  pisos.removeAt(index);
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

  void _onPisoClicked(int index) {
    if (pisos[index]['nombre'] == 'Piso 1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ParkingOverviewScreen(
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoDataFoundScreen(
            pisoNombre: pisos[index]['nombre'],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pisos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _agregarPiso,
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(pisos.length, (index) {
            return _buildCard(
              context: context,
              index: index,
              title: pisos[index]['nombre'],
              subtitle: 'Ver más detalles',
              icon: Icons.location_on,
              color: pisos[index]['color'],
              onPressed: () {
                _onPisoClicked(index); // Llamamos a _onPisoClicked
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
                    onPressed: () => _editarPiso(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPiso(index),
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
