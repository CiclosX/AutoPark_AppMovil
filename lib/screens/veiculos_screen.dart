import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class Vehiculo {
  final String id;
  final String color;
  final String marca;
  final String modelo;
  final String placa;

  Vehiculo({
    required this.id,
    required this.color,
    required this.marca,
    required this.modelo,
    required this.placa,
  });
}

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  _VehiculosScreenState createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final List<Vehiculo> _vehiculos = [];

  final _formKey = GlobalKey<FormState>();
  final _colorController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _cargarVehiculos();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _placaController.dispose();
    super.dispose();
  }

  void _cargarVehiculos() async {
    try {
      QuerySnapshot snapshot = await _db.collection('vehiculos').get();
      setState(() {
        _vehiculos.clear();
        for (var doc in snapshot.docs) {
          _vehiculos.add(Vehiculo(
            id: doc.id,
            color: doc['color'],
            marca: doc['marca'],
            modelo: doc['modelo'],
            placa: doc['placa'],
          ));
        }
      });
    } catch (e) {
      print('Error al cargar vehículos: $e');
    }
  }

  void _guardarVehiculo() async {
    if (_formKey.currentState!.validate()) {
      final vehiculo = {
        'color': _colorController.text,
        'marca': _marcaController.text,
        'modelo': _modeloController.text,
        'placa': _placaController.text,
      };

      try {
        if (_editingId == null) {
          await _db.collection('vehiculos').add(vehiculo);
        } else {
          await _db.collection('vehiculos').doc(_editingId).update(vehiculo);
        }
        _cargarVehiculos();
        Navigator.pop(context);
      } catch (e) {
        print('Error al guardar: $e');
      }
    }
  }

  void _eliminarVehiculo(String id) async {
    try {
      await _db.collection('vehiculos').doc(id).delete();
      _cargarVehiculos();
    } catch (e) {
      print('Error al eliminar: $e');
    }
  }

  void _openAddEditVehiculoDialog([Vehiculo? vehiculo]) {
    if (vehiculo != null) {
      _colorController.text = vehiculo.color;
      _marcaController.text = vehiculo.marca;
      _modeloController.text = vehiculo.modelo;
      _placaController.text = vehiculo.placa;
      _editingId = vehiculo.id;
    } else {
      _colorController.clear();
      _marcaController.clear();
      _modeloController.clear();
      _placaController.clear();
      _editingId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            vehiculo == null ? 'Agregar Vehículo' : 'Editar Vehículo',
            style: theme.textTheme.titleLarge,
          ),
          backgroundColor: theme.cardTheme.color,
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _colorController,
                    decoration: InputDecoration(
                      labelText: 'Color',
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) => value!.isEmpty ? 'Ingrese el color' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _marcaController,
                    decoration: InputDecoration(
                      labelText: 'Marca',
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) => value!.isEmpty ? 'Ingrese la marca' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modeloController,
                    decoration: InputDecoration(
                      labelText: 'Modelo',
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) => value!.isEmpty ? 'Ingrese el modelo' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _placaController,
                    decoration: InputDecoration(
                      labelText: 'Placa',
                      filled: true,
                      fillColor: theme.cardTheme.color,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: theme.textTheme.bodyMedium,
                    validator: (value) => value!.isEmpty ? 'Ingrese la placa' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar', 
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _guardarVehiculo,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Guardar', 
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
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
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Vehículos', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _openAddEditVehiculoDialog(),
          ),
        ],
      ),
      body: _vehiculos.isEmpty
          ? Center(
              child: Text(
                'No hay vehículos registrados',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.6),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _vehiculos.length,
                itemBuilder: (context, index) {
                  final vehiculo = _vehiculos[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions_car, 
                                  color: theme.primaryColor, 
                                  size: 40),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${vehiculo.marca} ${vehiculo.modelo}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Color: ${vehiculo.color}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    'Placa: ${vehiculo.placa}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, 
                                    color: theme.primaryColor),
                                onPressed: () => _openAddEditVehiculoDialog(vehiculo),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, 
                                    color: Colors.red),
                                onPressed: () => _eliminarVehiculo(vehiculo.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}