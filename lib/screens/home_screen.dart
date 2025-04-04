import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/usuario.dart';
import '../screens/auth_scren.dart';
import '../screens/floor_overview_screen.dart';
import '../screens/mis_vehiculos_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/recuperardatos_reservas.dart';
import '../screens/tarifa_overview_screen.dart';
import '../screens/users_screen.dart';
import '../services/auth_services.dart';
import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Usuario? usuario;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    usuario = await authService.currentUser;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : const Color.fromRGBO(21, 101, 192, 1);

    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)),
      );
    }

    if (usuario == null) {
      return Scaffold(
        body: Center(child: Text("No hay usuario autenticado")),
      );
    }

    final isAdmin = usuario!.rol == 'admin';

    final List<Widget> _screens = [
      const FloorOverviewScreen(),
      const RecuperarDatosReservasScreen(),
      const MisVehiculosScreen(),
      if (isAdmin) const TarifaOverviewScreen(),
      if (isAdmin) const UsersScreen(),
    ];

    final List<BottomNavigationBarItem> _items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.event_available, size: 28),
        label: 'Disponibilidad',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.edit_calendar, size: 28),
        label: 'Reservas',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.directions_car, size: 28),
        label: 'Vehículos',
      ),
      if (isAdmin) const BottomNavigationBarItem(
        icon: Icon(Icons.attach_money, size: 28),
        label: 'Tarifas',
      ),
      if (isAdmin) const BottomNavigationBarItem(
        icon: Icon(Icons.people, size: 28),
        label: 'Usuarios',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoPark', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.3),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, authService),
            tooltip: "Cerrar sesión",
          ),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue, size: 22),
              ),
            ),
          )
        ],
      ),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
      body: Column(
        children: [
          if (isAdmin) _buildAdminHeader(primaryColor!),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
bottomNavigationBar: BottomNavigationBar(
  currentIndex: _selectedIndex,
  selectedItemColor: Theme.of(context).colorScheme.secondary,
  unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey[700],
  type: BottomNavigationBarType.fixed,
  onTap: (index) => setState(() => _selectedIndex = index),
  items: _items.map((item) {
    return BottomNavigationBarItem(
      icon: item.icon is Icon
          ? Icon(
              (item.icon as Icon).icon, // Forzar el cast a Icon
              size: 30,
              color: (item.icon as Icon).color?.withOpacity(0.8),
            )
          : item.icon, // Si no es un Icon, dejarlo como está
      label: item.label,
    );
  }).toList(),
)


    );
  }

  Widget _buildAdminHeader(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2),
            blurRadius: 6,
          )
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.admin_panel_settings, color: Colors.blue, size: 28),
          SizedBox(width: 8),
          Text(
            'ADMINISTRADOR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AuthService authService) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        title: Text('Cerrar sesión', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: Text('¿Estás seguro que deseas salir?',
            style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.black87)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Salir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authService.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }
}
