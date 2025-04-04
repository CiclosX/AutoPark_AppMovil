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
import 'package:autopark_appmovil/providers/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color primaryBlue = Color.fromRGBO(21, 101, 192, 1);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : primaryBlue;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Cerrar sesión',
            onPressed: () => _confirmLogout(context, authService),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryBlue, size: 20),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: FutureBuilder<Usuario?>(
        future: authService.currentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "No hay usuario autenticado",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
            );
          }

          final usuario = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (usuario.rol == 'admin') 
                  _buildAdminHeader(isDarkMode, theme, primaryColor ?? HomeScreen.primaryBlue),
                Expanded(
                  child: ListView(
                    children: [
                      if (usuario.rol == 'admin') ...[
                        _buildCard(
                          title: 'Gestionar Usuarios',
                          subtitle: 'Ver y administrar usuarios',
                          icon: Icons.people,
                          color: Colors.blue,
                          isDarkMode: isDarkMode,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UsersScreen()),
                          ),
                        ),
                        _buildCard(
                          title: 'Estacionamiento',
                          subtitle: 'Tarifas y Espacios',
                          icon: Icons.attach_money,
                          color: Colors.green,
                          isDarkMode: isDarkMode,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TarifaOverviewScreen()),
                          ),
                        ),
                      ],
                      _buildCard(
                        title: 'Mis Vehículos',
                        subtitle: 'Gestión de mis vehículos',
                        icon: Icons.directions_car_filled,
                        color: Colors.blueAccent,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MisVehiculosScreen()),
                        ),
                      ),
                      _buildCard(
                        title: 'Disponibilidad Actual',
                        subtitle: 'Espacios Disponibles',
                        icon: Icons.event_available,
                        color: Colors.purple,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FloorOverviewScreen()),
                        ),
                      ),
                      _buildCard(
                        title: 'Reservas',
                        subtitle: 'Visualizar reservaciones',
                        icon: Icons.edit_calendar,
                        color: Colors.teal,
                        isDarkMode: isDarkMode,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecuperarDatosReservasScreen()),
                        ),
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

  Future<void> _confirmLogout(BuildContext context, AuthService authService) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    bool confirm = await showDialog(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          dialogBackgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        ),
        child: AlertDialog(
          title: Text(
            'Cerrar sesión',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
          content: Text(
            '¿Estás seguro que deseas salir?',
            style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Salir', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    ) ?? false;

    if (confirm) {
      await authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  Widget _buildAdminHeader(bool isDarkMode, ThemeData theme, Color primaryColor) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.admin_panel_settings, color: theme.primaryColor),
            const SizedBox(width: 8),
            Text(
              'ADMINISTRADOR',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
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
    required bool isDarkMode,
    VoidCallback? onPressed,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isDarkMode ? Colors.grey[800] : Colors.white,
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
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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