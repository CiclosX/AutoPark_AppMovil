import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/services/realtime_db_services.dart';

class TarifasScreen extends StatefulWidget {
  @override
  _TarifasScreenState createState() => _TarifasScreenState();
}

class _TarifasScreenState extends State<TarifasScreen> {
  double tarifaActual = 10.50;
  TextEditingController tarifaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tarifaController.text = tarifaActual.toString();
  }

  @override
  Widget build(BuildContext context) {
    final realtimeDbService = Provider.of<RealtimeDbService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarifas'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'La tarifa actual es de \$$tarifaActual / Hr.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Precio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Editar'),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: tarifaController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      suffixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Hora'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Agregar nueva tarifa
              },
              child: Text('Agregar'),
              style: ElevatedButton.styleFrom(
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tarifaActual = double.tryParse(tarifaController.text) ?? tarifaActual;
                });
                // Guardar en base de datos o backend
                //realtimeDbService.saveTarifa(tarifaActual);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tarifas guardadas correctamente')),
                );
              },
              child: Text('Guardar Tarifas'),
              style: ElevatedButton.styleFrom(              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tarifaController.dispose();
    super.dispose();
  }
}