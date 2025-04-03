import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  // Función para cambiar el rol del usuario en Firestore
  Future<void> _changeRole(String userId, String currentRole) async {
    String newRole = currentRole == 'admin' ? 'usuario' : 'admin';

    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
        'rol': newRole,
      });
      print('Rol actualizado correctamente');
    } catch (e) {
      print('Error al actualizar rol: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay usuarios registrados.'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              String userId = user.id;
              String email = user['email'];
              String role = user['rol'];

              return ListTile(
                title: Text(email),
                subtitle: Text('Rol: $role'),
                trailing: ElevatedButton(
                  onPressed: () => _changeRole(userId, role),
                  child: const Text('Cambiar Rol'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
