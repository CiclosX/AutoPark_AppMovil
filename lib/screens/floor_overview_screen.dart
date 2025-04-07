import 'package:autopark_appmovil/models/floor_model.dart';
import 'package:autopark_appmovil/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_owner_screen.dart';
import 'package:autopark_appmovil/screens/no_data_found_screen.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class FloorOverviewScreen extends StatefulWidget {
  const FloorOverviewScreen({super.key});

  @override
  _FloorOverviewScreenState createState() => _FloorOverviewScreenState();
}

class _FloorOverviewScreenState extends State<FloorOverviewScreen> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  void _agregarPiso() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    TextEditingController nombreController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text("Agregar Piso", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            content: TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: "Nombre del piso",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar", style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              TextButton(
                onPressed: () async {
                  if (nombreController.text.isNotEmpty) {
                    await _firestoreServices.agregarPiso('piso', {
                      'nombre': nombreController.text,
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text("Agregar", style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editarPiso(FloorModel piso) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    TextEditingController nombreController = TextEditingController(text: piso.nombre);
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text("Editar Piso", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            content: TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: "Nuevo nombre del piso",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar", style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              TextButton(
                onPressed: () async {
                  await _firestoreServices.editarPiso('piso', piso.id, {
                    'nombre': nombreController.text,
                  });
                  Navigator.pop(context);
                },
                child: Text("Guardar", style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _eliminarPiso(FloorModel piso) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text("Confirmar Eliminación", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            content: Text("¿Estás seguro de que deseas eliminar este piso?", 
                style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800])),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancelar", style: TextStyle(color: Theme.of(context).primaryColor)),
              ),
              TextButton(
                onPressed: () async {
                  await _firestoreServices.eliminarPiso('piso', piso.id);
                  Navigator.pop(context);
                },
                child: Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pisos', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _agregarPiso,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<List<FloorModel>>(
          stream: _firestoreServices.obtenerPisos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', 
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: theme.primaryColor));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No hay pisos disponibles", 
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                FloorModel piso = snapshot.data![index];
                return _buildCard(
                  context: context,
                  piso: piso,
                  isDarkMode: isDarkMode,
                  theme: theme,
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
    required bool isDarkMode,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: () => _onPisoClicked(piso),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[800], size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        piso.nombre,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ver más detalles',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue[800]),
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