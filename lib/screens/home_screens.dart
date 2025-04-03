import 'package:autopark_appmovil/models/usuario.dart';
import 'package:autopark_appmovil/screens/auth_scren.dart';
import 'package:autopark_appmovil/screens/floor_overview_screen.dart';
import 'package:autopark_appmovil/screens/mis_vehiculos_screen.dart';
import 'package:autopark_appmovil/screens/profile_screen.dart';
import 'package:autopark_appmovil/screens/recuperardatos_reservas.dart';
import 'package:autopark_appmovil/screens/tarifa_overview_screen.dart';
import 'package:autopark_appmovil/screens/users_screen.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color.fromRGBO(21, 101, 192, 1);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
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
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              }
            },
          ),
          const SizedBox(width: 8),
          // En la parte de las acciones del AppBar, reemplaza el CircleAvatar actual con:
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryBlue, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: FutureBuilder<Usuario?>(
        future: authService.currentUser,
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
                if (usuario.rol == 'admin') _buildAdminHeader(),
                Expanded(
                  child: ListView(
                    children: [
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

  Widget _buildAdminHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[400]!, width: 1.5),
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
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
