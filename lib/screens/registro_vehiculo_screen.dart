import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/services/vehiculos_services.dart';
import 'package:flutter/material.dart';

class RegistroVehiculoScreen extends StatefulWidget {
  @override
  _RegistroVehiculoScreenState createState() => _RegistroVehiculoScreenState();
}

class _RegistroVehiculoScreenState extends State<RegistroVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  String _errorMessage = '';

  void _registrarVehiculo() async {
    final color = _colorController.text.trim();
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final placa = _placaController.text.trim();

    if (color.isEmpty || marca.isEmpty || modelo.isEmpty || placa.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresa todos los campos.';
      });
      return;
    }

    try {
      // Llamamos al servicio para registrar el vehículo
      VehiculoService vehiculoService = VehiculoService();
      await vehiculoService.registrarVehiculo(color, marca, modelo, placa);

      // Si el registro es exitoso, redirigimos al usuario a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Reemplaza con tu pantalla principal
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al registrar el vehículo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Vehículo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'Ingresa el color del vehículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El color es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  hintText: 'Ingresa la marca del vehículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La marca es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  hintText: 'Ingresa el modelo del vehículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El modelo es obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  hintText: 'Ingresa la placa del vehículo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La placa es obligatoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registrarVehiculo(); // Si el formulario es válido, registramos el vehículo
                  }
                },
                child: const Text('Registrar Vehículo'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
