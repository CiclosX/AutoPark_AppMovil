import 'package:autopark_appmovil/main.dart';
import 'package:autopark_appmovil/screens/floor_overview_screen.dart';
import 'package:autopark_appmovil/screens/recuperardatos_reservas.dart';
import 'package:autopark_appmovil/screens/tarifa_overview_screen.dart';
import 'package:autopark_appmovil/screens/veiculos_screen.dart';
import 'package:autopark_appmovil/screens/signin_screen.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Definimos el color azul principal como constante
  static const Color primaryBlue = Color.fromRGBO(21, 101, 192, 1);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bienvenido', style: TextStyle(color: Colors.white)),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Cerrar sesión',
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar sesión'),
                        content: const Text('¿Estás seguro que deseas salir?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Salir', style: TextStyle(color: primaryBlue)),
                          ),
                        ],
                      ),
                    ) ?? false;

                    if (confirm) {
                      await _authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>  SigninScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: primaryBlue, size: 20),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: primaryBlue, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      'ADMINISTRADOR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildCard(
                    title: 'Estacionamiento',
                    subtitle: 'Tarifas y Espacios',
                    icon: Icons.attach_money,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TarifaOverviewScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Vehiculos',
                    subtitle: 'Gestion de vehiculos',
                    icon: Icons.directions_car,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehiculosScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Disponibilidad',
                    subtitle: 'Espacios Disponibles',
                    icon: Icons.event_available,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FloorOverviewScreen(),
                        ),
                      );
                    },
                  ),
                  _buildCard(
                    title: 'Reservas',
                    subtitle: 'Visualizar reservaciones',
                    icon: Icons.edit_calendar,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecuperarDatosReservasScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // obtenerUsuarios();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Obtener usuarios"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: primaryBlue, size: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}