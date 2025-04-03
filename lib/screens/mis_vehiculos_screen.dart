import 'package:autopark_appmovil/services/vehiculos_services.dart';
import 'package:flutter/material.dart';

class MisVehiculosScreen extends StatefulWidget {
  @override
  _MisVehiculosScreenState createState() => _MisVehiculosScreenState();
}

class _MisVehiculosScreenState extends State<MisVehiculosScreen> {
  // Definición del color primaryBlue
  final Color primaryBlue = Color.fromARGB(255,21,101,192); // Puedes ajustar este color según tus preferencias
  
  List<Map<String, dynamic>> vehiculos = [];
  final VehiculoService _vehiculoService = VehiculoService();

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  void _cargarVehiculos() async {
    List<Map<String, dynamic>> lista = await _vehiculoService.obtenerVehiculosUsuario();
    setState(() {
      vehiculos = lista;
    });
  }

  void _mostrarDialogEditarVehiculo(Map<String, dynamic> vehiculo, String vehiculoId) {
    TextEditingController colorController = TextEditingController(text: vehiculo['color']);
    TextEditingController marcaController = TextEditingController(text: vehiculo['marca']);
    TextEditingController modeloController = TextEditingController(text: vehiculo['modelo']);
    TextEditingController placaController = TextEditingController(text: vehiculo['placa']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Vehículo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: colorController, decoration: const InputDecoration(labelText: "Color")),
              TextField(controller: marcaController, decoration: const InputDecoration(labelText: "Marca")),
              TextField(controller: modeloController, decoration: const InputDecoration(labelText: "Modelo")),
              TextField(controller: placaController, decoration: const InputDecoration(labelText: "Placa")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cerrar sin guardar
              child: const Text("Cancelar"),
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
                _cargarVehiculos(); // Recargar la lista después de editar
              },
              child: const Text("Guardar"),
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
        title: const Text("Mis Vehículos", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
      ),
      
      body: vehiculos.isEmpty
          ? const Center(child: Text("No tienes vehículos registrados"))
          : ListView.builder(
              itemCount: vehiculos.length,
              itemBuilder: (context, index) {
                var vehiculo = vehiculos[index];
                String vehiculoId = vehiculo['id']; // Necesitamos el ID para editar

                return Card(
                  child: ListTile(
                    title: Text("${vehiculo['marca']} - ${vehiculo['modelo']}"),
                    subtitle: Text("Color: ${vehiculo['color']} | Placa: ${vehiculo['placa']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _mostrarDialogEditarVehiculo(vehiculo, vehiculoId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}