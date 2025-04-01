import 'package:flutter/material.dart';
import 'package:autopark_appmovil/models/tarifa_model.dart';
import 'package:autopark_appmovil/services/firestore_services.dart';

class TarifaOverviewScreen extends StatefulWidget {
  const TarifaOverviewScreen({super.key});

  @override
  _TarifaOverviewScreenState createState() => _TarifaOverviewScreenState();
}

class _TarifaOverviewScreenState extends State<TarifaOverviewScreen> {
  final FirestoreServices _firestoreServices = FirestoreServices();

  void _agregarTarifa() {
    TextEditingController tarifaController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Tarifa"),
          content: TextField(
            controller: tarifaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Ingrese la tarifa"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (tarifaController.text.isNotEmpty) {
                  await _firestoreServices.agregarTarifa({
                    'tarifa': double.parse(tarifaController.text),
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Agregar"),
            ),
          ],
        );
      },
    );
  }

  void _editarTarifa(TarifaModel tarifa) {
    TextEditingController tarifaController =
        TextEditingController(text: tarifa.tarifa.toString());
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Editar Tarifa"),
          content: TextField(
            controller: tarifaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Nueva tarifa"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _firestoreServices.editarTarifa(tarifa.id, {
                  'tarifa': double.parse(tarifaController.text),
                });
                Navigator.pop(context);
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  void _eliminarTarifa(TarifaModel tarifa) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Eliminación"),
          content: const Text("¿Estás seguro de que deseas eliminar esta tarifa?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await _firestoreServices.eliminarTarifa(tarifa.id);
                Navigator.pop(context);
              },
              child: const Text("Eliminar"),
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
        title: const Text('Tarifas'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _agregarTarifa,
          ),
        ],
      ),
      body: StreamBuilder<List<TarifaModel>>(
        stream: _firestoreServices.obtenerTarifas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay tarifas disponibles"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              TarifaModel tarifa = snapshot.data![index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text("Tarifa: \$${tarifa.tarifa}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editarTarifa(tarifa),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarTarifa(tarifa),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
