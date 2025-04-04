import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:autopark_appmovil/providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentUserIdStream = authService.user;
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final primaryColor = isDarkMode ? Colors.blue[900] : Colors.blue[800];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      body: StreamBuilder<User?>(
        stream: currentUserIdStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return Center(
              child: Text(
                'No se encontró información del usuario.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final currentUserId = userSnapshot.data!.uid;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('usuarios')
                .doc(currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    'No se encontró información del usuario.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String email = userData['email'] ?? '';
              String nombre = userData['nombre'] ?? 'Sin nombre';
              String rol = userData['rol'] ?? 'usuario';
              String foto = userData['foto'] ?? '';
              Timestamp? creadoEn = userData['creadoEn'] as Timestamp?;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,
                      backgroundImage: foto.isNotEmpty 
                          ? NetworkImage(foto) 
                          : null,
                      child: foto.isEmpty 
                          ? const Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      nombre,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: isDarkMode ? Colors.grey[800] : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildProfileInfoRow(
                              context: context,
                              label: 'Rol', 
                              value: rol,
                            ),
                            const Divider(height: 20),
                            _buildProfileInfoRow(
                              context: context,
                              label: 'Miembro desde', 
                              value: creadoEn?.toDate().toString().split(' ')[0] ?? 'Fecha no disponible',
                            ),
                            const Divider(height: 20),
                            _buildThemeSwitch(
                              context: context,
                              isDarkMode: isDarkMode,
                              primaryColor: primaryColor ?? Colors.blue,
                              onChanged: (value) {
                                themeProvider.toggleTheme(value);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (rol == 'admin')
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.admin_panel_settings, 
                                color: primaryColor, 
                                size: 40,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'ADMINISTRADOR',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileInfoRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSwitch({
    required BuildContext context,
    required bool isDarkMode,
    required Color primaryColor,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Modo Oscuro',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: onChanged,
            activeColor: primaryColor,
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}