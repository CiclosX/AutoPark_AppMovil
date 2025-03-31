import 'package:autopark_appmovil/models/floor_model.dart';
import 'package:autopark_appmovil/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_owner_screen.dart';
import 'package:autopark_appmovil/screens/no_data_found_screen.dart';

class FloorOverviewScreen extends StatefulWidget {
  const FloorOverviewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FloorOverviewScreenState createState() => _FloorOverviewScreenState();
}
class _FloorOverviewScreenState extends State<FloorOverviewScreen> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  // Método para agregar un nuevo piso
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
            onPressed: () async {
              if (nombreController.text.isNotEmpty) {
                // Pasar el mapa con el nombre del piso
                await _firestoreServices.agregarPiso('piso', {
                  'nombre': nombreController.text,
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Agregar"),
          ),
        ],
      );
    },
  );
}


  // Método para editar un piso
  void _editarPiso(FloorModel piso) {
  TextEditingController nombreController = TextEditingController(text: piso.nombre);
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
            onPressed: () async {
              // Pasar el docId y los datos para editar el piso
              await _firestoreServices.editarPiso('piso', piso.id, {
                'nombre': nombreController.text, // Actualizar el nombre
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


  // Método para eliminar un piso
  void _eliminarPiso(FloorModel piso) {
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
            onPressed: () async {
              await _firestoreServices.eliminarPiso('piso', piso.id); // Pasar la colección y el docId
              Navigator.pop(context);
            },
            child: const Text("Eliminar"),
          ),
        ],
      );
    },
  );
}


  // Método para manejar el clic en un piso
  void _onPisoClicked(FloorModel piso) {
    if (piso.nombre == 'Piso 1') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ParkingOverviewScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoDataFoundScreen(
            pisoNombre: piso.nombre,
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
        child: StreamBuilder<List<FloorModel>>(
          stream: _firestoreServices.obtenerPisos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No hay pisos disponibles"));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FloorModel piso = snapshot.data![index];
                return _buildCard(
                  context: context,
                  piso: piso,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required FloorModel piso,
  }) {
    return GestureDetector(
      onTap: () => _onPisoClicked(piso),
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
                  const Icon(Icons.location_on, color: Colors.blue, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        piso.nombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ver más detalles',
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
                    onPressed: () => _editarPiso(piso),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _eliminarPiso(piso),
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
