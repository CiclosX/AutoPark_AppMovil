import 'package:autopark_appmovil/services/vehiculos_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class MisVehiculosScreen extends StatefulWidget {
  const MisVehiculosScreen({super.key});

  @override
  _MisVehiculosScreenState createState() => _MisVehiculosScreenState();
}

class _MisVehiculosScreenState extends State<MisVehiculosScreen> {
  final Color primaryBlue = const Color.fromARGB(255, 21, 101, 192);
  List<Map<String, dynamic>> vehiculos = [];
  final VehiculoService _vehiculoService = VehiculoService();

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  Future<void> _cargarVehiculos() async {
    List<Map<String, dynamic>> lista = await _vehiculoService.obtenerVehiculosUsuario();
    setState(() => vehiculos = lista);
  }

  void _mostrarDialogEditarVehiculo(Map<String, dynamic> vehiculo, String vehiculoId) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    TextEditingController colorController = TextEditingController(text: vehiculo['color']);
    TextEditingController marcaController = TextEditingController(text: vehiculo['marca']);
    TextEditingController modeloController = TextEditingController(text: vehiculo['modelo']);
    TextEditingController placaController = TextEditingController(text: vehiculo['placa']);

    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              "Editar Vehículo",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: colorController,
                    decoration: InputDecoration(
                      labelText: "Color",
                      labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  TextField(
                    controller: marcaController,
                    decoration: InputDecoration(
                      labelText: "Marca",
                      labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  TextField(
                    controller: modeloController,
                    decoration: InputDecoration(
                      labelText: "Modelo",
                      labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  TextField(
                    controller: placaController,
                    decoration: InputDecoration(
                      labelText: "Placa",
                      labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    ),
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _vehiculoService.editarVehiculo(
                    vehiculoId,
                    colorController.text,
                    marcaController.text,
                    modeloController.text,
                    placaController.text,
                  );
                  Navigator.pop(context);
                  _cargarVehiculos();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text("Guardar"),
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
    final primaryColor = isDarkMode ? Colors.blue[900] : primaryBlue;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Vehículos", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: vehiculos.isEmpty
          ? Center(
              child: Text(
                "No tienes vehículos registrados",
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            )
          : ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                var vehiculo = vehiculos[index];
                String vehiculoId = vehiculo['id'];

                return Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      "${vehiculo['marca']} - ${vehiculo['modelo']}",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      "Color: ${vehiculo['color']} | Placa: ${vehiculo['placa']}",
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: theme.primaryColor),
                      onPressed: () => _mostrarDialogEditarVehiculo(vehiculo, vehiculoId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}