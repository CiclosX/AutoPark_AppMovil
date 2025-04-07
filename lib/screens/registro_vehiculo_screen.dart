import 'package:autopark_appmovil/screens/home_screens.dart';
import 'package:autopark_appmovil/services/vehiculos_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class RegistroVehiculoScreen extends StatefulWidget {
  const RegistroVehiculoScreen({super.key});

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
      VehiculoService vehiculoService = VehiculoService();
      await vehiculoService.registrarVehiculo(color, marca, modelo, placa);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al registrar el vehículo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Vehículo", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    labelText: 'Color',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    hintText: 'Ingresa el color del vehículo',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : null),
                    border: const OutlineInputBorder(),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[800] : null,
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                  decoration: InputDecoration(
                    labelText: 'Marca',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    hintText: 'Ingresa la marca del vehículo',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : null),
                    border: const OutlineInputBorder(),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[800] : null,
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    hintText: 'Ingresa el modelo del vehículo',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : null),
                    border: const OutlineInputBorder(),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[800] : null,
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                  decoration: InputDecoration(
                    labelText: 'Placa',
                    labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : null),
                    hintText: 'Ingresa la placa del vehículo',
                    hintStyle: TextStyle(color: isDarkMode ? Colors.grey[500] : null),
                    border: const OutlineInputBorder(),
                    filled: isDarkMode,
                    fillColor: isDarkMode ? Colors.grey[800] : null,
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                      style: TextStyle(color: Colors.red[400]),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registrarVehiculo();
                    }
                  },
                  child: const Text('Registrar Vehículo'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}