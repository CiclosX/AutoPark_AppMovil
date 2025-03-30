import 'package:autopark_appmovil/models/user_model.dart';
import 'package:autopark_appmovil/services/firestore_services.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {

  final FirestoreServices _firestoreServices = FirestoreServices();
  //Controladores para las cajas de texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios en firebase'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nombreController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
            ),
          ),
          TextField(
            controller: _correoController,
            decoration: const InputDecoration(
              labelText: 'Correo',
            ),
          ),
          TextField(
            controller: _telefonoController,
            decoration: const InputDecoration(
              labelText: 'Telefono',
            ),
          ),
          TextField(
            controller: _tipoController,
            decoration: const InputDecoration(
              labelText: 'Tipo',
            ),
          ),
          const ElevatedButton(
            onPressed: null,
            child: Text('Agregar usuario'),
          ),

          //aqui se van a mostrar los usuarios
          Expanded(
            child: StreamBuilder(
              stream: _firestoreServices.getUser('usuarios'),
              builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                if (snapshot.hasError) {
                  return  Center(
                    child: Text('Algo salio mal ${snapshot.error}'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data!.map((UserModel user){
                    return ListTile(
                      title: Text(user.nombre),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Correo: ${user.correo}'),
                          Text('Telefono: ${user.telefono.toString()}'),
                          Text('Tipo: ${user.tipo}'),
                        ],
                      ),
                      onTap: null,
                      trailing: const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.delete),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

