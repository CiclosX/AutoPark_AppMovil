import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUserIdStream = authService.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<User?>(
        stream: currentUserIdStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text('No se encontró información del usuario.'));
          }

          final currentUserId = userSnapshot.data!.uid;

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('usuarios')
                .doc(currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No se encontró información del usuario.'));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;
              String email = userData['email'] ?? '';
              String nombre = userData['nombre'] ?? 'Sin nombre';
              String rol = userData['rol'] ?? 'usuario';
              String foto = userData['foto'] ?? '';
              Timestamp? creadoEn = userData['creadoEn'] as Timestamp?;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue,
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
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildProfileInfoRow(
                              context: context,
                              label: 'Rol', 
                              value: rol,
                            ),
                            const Divider(),
                            _buildProfileInfoRow(
                              context: context,
                              label: 'Miembro desde', 
                              value: creadoEn?.toDate().toString().split(' ')[0] ?? 'Fecha no disponible',
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.admin_panel_settings, color: Colors.blue, size: 40),
                              const SizedBox(width: 16),
                              Text(
                                'ADMINISTRADOR',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}