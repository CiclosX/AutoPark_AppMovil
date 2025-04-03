import 'package:autopark_appmovil/models/usuario.dart';
import 'package:autopark_appmovil/screens/auth_scren.dart';
import 'package:autopark_appmovil/screens/floor_overview_screen.dart';
import 'package:autopark_appmovil/screens/mis_vehiculos_screen.dart';
import 'package:autopark_appmovil/screens/recuperardatos_reservas.dart';
import 'package:autopark_appmovil/screens/tarifa_overview_screen.dart';
import 'package:autopark_appmovil/screens/users_screen.dart';
import 'package:autopark_appmovil/screens/veiculos_screen.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

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
                                child: const Text('Salir'),
                              ),
                            ],
                          ),
                        ) ??
                        false;

                    if (confirm) {
                      await authService.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.blue[800], size: 20),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(21, 101, 192, 1),
        elevation: 0,
      ),
      body: FutureBuilder<Usuario?>(
        future: authService.currentUser, // Obtiene el usuario autenticado
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No hay usuario autenticado"));
          }

          final usuario = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Muestra "Administrador" si el usuario es admin
                if (usuario.rol == 'admin')
                  _buildAdminHeader(),

                Expanded(
                  child: ListView(
                    children: [
                      // Botones de navegación según el rol
                      if (usuario.rol == 'admin') ...[
                        _buildCard(
                          title: 'Gestionar Usuarios',
                          subtitle: 'Ver y administrar usuarios',
                          icon: Icons.people,
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UsersScreen()),
                            );
                          },
                        ),
                        _buildCard(
                          title: 'Estacionamiento',
                          subtitle: 'Tarifas y Espacios',
                          icon: Icons.attach_money,
                          color: Colors.green,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TarifaOverviewScreen()),
                            );
                          },
                        ),
                      ],
                      _buildCard(
                        title: 'Vehículos',
                        subtitle: 'Gestión de vehículos',
                        icon: Icons.directions_car,
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const VehiculosScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        title: 'Mis Vehículos',
                        subtitle: 'Gestión de mis vehículos',
                        icon: Icons.directions_car_filled,
                        color: Colors.blueAccent,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MisVehiculosScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        title: 'Disponibilidad Actual',
                        subtitle: 'Espacios Disponibles',
                        icon: Icons.event_available,
                        color: Colors.purple,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FloorOverviewScreen()),
                          );
                        },
                      ),
                      _buildCard(
                        title: 'Reservas',
                        subtitle: 'Visualizar reservaciones',
                        icon: Icons.edit_calendar,
                        color: Colors.teal,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecuperarDatosReservasScreen()),
                          );
                        },
                      ),
                      _buildCard(title: 'Usuarios',
                        subtitle: 'Ver y administrar usuarios',
                        icon: Icons.people,
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UsersScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Header para los administradores
  Widget _buildAdminHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[400]!, width: 1.5),
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
    );
  }

  /// Construye cada tarjeta de navegación
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
