import 'package:autopark_appmovil/screens/floor_overview_screen.dart';
import 'package:autopark_appmovil/screens/tarifa_overview_screen.dart';
import 'package:autopark_appmovil/screens/veiculos_screen.dart';
import 'package:autopark_appmovil/screens/signin_screen.dart'; // Importa la pantalla de login
import 'package:autopark_appmovil/services/auth_services.dart'; // Importa el AuthService
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bienvenido',
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                // Botón de cerrar sesión
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Cerrar sesión',
                  onPressed: () async {
                    // Mostrar diálogo de confirmación
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
                            child: const Text('Salir'),
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
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[800],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Juaquin',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue[400]!,
                    width: 1.5,
                  ),
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
                    Icon(Icons.home, color: Colors.blue[800]),
                    const SizedBox(width: 8),
                    Text(
                      'ADMINISTRADOR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
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
                  // 1. Estacionamiento
                  _buildCard(
                    title: 'Estacionamiento',
                    subtitle: 'Tarifas y Espacios',
                    icon: Icons.attach_money,
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TarifaOverviewScreen(),
                        ),
                      );
                    },
                  ),
                  
                  // 2. Disponibilidad
                  _buildCard(
                    title: 'Disponibilidad Actual',
                    subtitle: 'Espacios Disponibles',
                    icon: Icons.event_available,
                    color: Colors.orange,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FloorOverviewScreen(),
                        ),
                      );
                    },
                  ),
                  
                  // 3. Reservas
                  _buildCard(
                    title: 'Reservas',
                    subtitle: '6 Reservas',
                    icon: Icons.calendar_today,
                    color: Colors.red,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehiculosScreen(),
                        ),
                      );
                    },
                  ),
                  
                  // 4. Gestionar Reserva
                  _buildCard(
                    title: 'Gestionar Reservas',
                    subtitle: 'Administrar reservaciones',
                    icon: Icons.edit_calendar,
                    color: Colors.purple,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehiculosScreen(),
                        ),
                      );
                    },
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
    required Color color,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: color, size: 40),
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
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