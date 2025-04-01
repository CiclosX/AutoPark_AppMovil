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
          title: Text(vehiculo == null ? 'Agregar Vehículo' : 'Editar Vehículo'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el color' : null,
                ),
                TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (value) => value!.isEmpty ? 'Ingrese la marca' : null,
                ),
                TextFormField(
                  controller: _modeloController,
                  decoration: const InputDecoration(labelText: 'Modelo'),
                  validator: (value) => value!.isEmpty ? 'Ingrese el modelo' : null,
                ),
                TextFormField(
                  controller: _placaController,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  validator: (value) => value!.isEmpty ? 'Ingrese la placa' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _guardarVehiculo,
              child: const Text('Guardar'),
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
        title: const Text('Vehículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddEditVehiculoDialog(),
          ),
        ],
      ),
      body: _vehiculos.isEmpty
          ? const Center(child: Text('No hay vehículos registrados'))
          : ListView.builder(
              itemCount: _vehiculos.length,
              itemBuilder: (context, index) {
                final vehiculo = _vehiculos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.directions_car, size: 40),
                    title: Text('${vehiculo.marca} ${vehiculo.modelo}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Color: ${vehiculo.color}'),
                        Text('Placa: ${vehiculo.placa}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openAddEditVehiculoDialog(vehiculo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _eliminarVehiculo(vehiculo.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}