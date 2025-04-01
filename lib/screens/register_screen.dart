import 'package:flutter/material.dart';
import 'package:autopark_appmovil/services/auth_services.dart';
import 'package:autopark_appmovil/screens/signin_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para información de usuario
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _userType = 'Usuario';

  // Controladores para información de vehículo
  final TextEditingController _vehiclePlateController = TextEditingController();
  final TextEditingController _vehicleBrandController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();
  final TextEditingController _vehicleColorController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Completo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[800],
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Sección de Información Personal
              _buildSectionHeader('Información Personal'),
              _buildTextField(_nameController, 'Nombre Completo', Icons.person, validator: _validateName),
              _buildTextField(_emailController, 'Correo Electrónico', Icons.email, 
                  keyboardType: TextInputType.emailAddress, validator: _validateEmail),
              _buildTextField(_phoneController, 'Teléfono', Icons.phone, 
                  keyboardType: TextInputType.phone, validator: _validatePhone),
              
              // Dropdown para Tipo de Usuario
              _buildDropdownFormField(),

              // Sección de Contraseña
              _buildSectionHeader('Seguridad'),
              _buildTextField(_passwordController, 'Contraseña', Icons.lock, 
                  isPassword: true, validator: _validatePassword),
              _buildTextField(_confirmPasswordController, 'Confirmar Contraseña', Icons.lock_outline, 
                  isPassword: true, validator: _validateConfirmPassword),

              // Sección de Vehículo
              _buildSectionHeader('Vehículo Principal'),
              _buildTextField(_vehiclePlateController, 'Placa del Vehículo', Icons.directions_car),
              _buildTextField(_vehicleBrandController, 'Marca', Icons.branding_watermark),
              _buildTextField(_vehicleModelController, 'Modelo', Icons.model_training),
              _buildTextField(_vehicleColorController, 'Color', Icons.color_lens),

              const SizedBox(height: 30),
              
              // Botón de Registro
              _buildRegisterButton(context),
              
              // Enlace para iniciar sesión
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos auxiliares para construir los widgets
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDropdownFormField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: _userType,
        decoration: InputDecoration(
          labelText: 'Tipo de Usuario',
          prefixIcon: Icon(Icons.person_pin),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: ['Administrador', 'Usuario']
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _userType = value!;
          });
        },
        validator: (value) => value == null ? 'Selecciona un tipo' : null,
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _registerUser(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Registrarse',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  SigninScreen()),
          );
        },
        child: const Text(
          '¿Ya tienes cuenta? Inicia sesión',
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
  }

  // Métodos de validación
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu nombre';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Correo electrónico inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu teléfono';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Teléfono debe tener 10 dígitos';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  // Método para registrar usuario
  Future<void> _registerUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.registerUserWithVehicle(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: _phoneController.text,
        userType: _userType,
        vehiclePlate: _vehiclePlateController.text,
        vehicleBrand: _vehicleBrandController.text,
        vehicleModel: _vehicleModelController.text,
        vehicleColor: _vehicleColorController.text,
      );
      
      // Registro exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso!')),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  SigninScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}