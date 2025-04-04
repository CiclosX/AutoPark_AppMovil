import 'package:flutter/material.dart';
import 'package:autopark_appmovil/screens/parking_screen.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

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
            title: Text(
              "Agregar Espacio",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: "Nombre del espacio",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    espacios.add({
                      'id': 'espacio_${espacios.length + 1}',
                      'nombre': nombreController.text.isNotEmpty 
                          ? nombreController.text 
                          : 'Espacio ${espacios.length + 1}',
                      'cajones': 5,
                      'color': Colors.blue,
                    });
                  });
                  Navigator.pop(context);
                },
                child: const Text("Agregar"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editarEspacio(int index) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    TextEditingController nombreController = TextEditingController(text: espacios[index]['nombre']);
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              "Editar Espacio",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: "Nuevo nombre del espacio",
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
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
          ),
        );
      },
    );
  }

  void _eliminarEspacio(int index) {
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
            title: Text(
              "Confirmar Eliminación",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: Text(
              "¿Estás seguro de que deseas eliminar este espacio?",
              style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    espacios.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lugares', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _agregarEspacio,
          ),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: espacios.length,
          itemBuilder: (context, index) {
            return _buildCard(
              context: context,
              index: index,
              title: espacios[index]['nombre'],
              subtitle: 'Ver más detalles',
              icon: Icons.local_parking,
              color: espacios[index]['color'],
              isDarkMode: isDarkMode,
              theme: theme,
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
          },
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
    required bool isDarkMode,
    required ThemeData theme,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
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
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
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
                    icon: Icon(Icons.edit, color: theme.primaryColor),
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