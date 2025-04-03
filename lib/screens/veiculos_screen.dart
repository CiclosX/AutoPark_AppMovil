import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        return AlertDialog(
          title: Text(
            vehiculo == null ? 'Agregar Vehículo' : 'Editar Vehículo',
            style: TextStyle(color: Colors.grey[800]),
          ),
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
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Ingrese el color' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _marcaController,
                    decoration: InputDecoration(
                      labelText: 'Marca',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Ingrese la marca' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _modeloController,
                    decoration: InputDecoration(
                      labelText: 'Modelo',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Ingrese el modelo' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _placaController,
                    decoration: InputDecoration(
                      labelText: 'Placa',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Ingrese la placa' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: _guardarVehiculo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Guardar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Vehículos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _openAddEditVehiculoDialog(),
          ),
        ],
      ),
      body: _vehiculos.isEmpty
          ? const Center(
              child: Text(
                'No hay vehículos registrados',
                style: TextStyle(color: Colors.grey),
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.directions_car, 
                                  color: Colors.blue, size: 40),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${vehiculo.marca} ${vehiculo.modelo}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Color: ${vehiculo.color}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Placa: ${vehiculo.placa}',
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
                                onPressed: () => _openAddEditVehiculoDialog(vehiculo),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
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