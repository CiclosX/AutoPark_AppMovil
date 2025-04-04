import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String pisoNombre;

  const NoDataFoundScreen({super.key, required this.pisoNombre});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];
    final theme = Theme.of(context);
    TextEditingController lugarController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos no encontrados', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron lugares disponibles para el $pisoNombre.',
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _mostrarDialogAgregarLugar(context, lugarController, isDarkMode),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
              ),
              child: const Text("Agregar Lugares"),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogAgregarLugar(
    BuildContext context, 
    TextEditingController controller,
    bool isDarkMode
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: AlertDialog(
            title: Text(
              "Agregar Lugar",
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Nombre del lugar",
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
                onPressed: () => _agregarLugar(context, controller),
                child: const Text("Agregar"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _agregarLugar(BuildContext context, TextEditingController controller) {
    if (controller.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lugar ${controller.text} agregado.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un nombre para el lugar.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}