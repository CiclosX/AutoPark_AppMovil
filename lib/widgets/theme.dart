import 'package:flutter/material.dart';

// Definimos el nuevo color azul
const Color customBlue = Color(0xFFFF007B); // RGB: 255, 0, 123, 255

// Aquí se define el tema para la aplicación.
final ThemeData customTheme = ThemeData(
  primarySwatch: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[200], // Color de fondo para los campos de texto
    labelStyle: const TextStyle(
      color: Colors.blueGrey, // Color del texto de la etiqueta
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: customBlue, width: 1), // Cambio al nuevo azul
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: customBlue, width: 1), // Cambio al nuevo azul
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: customBlue, width: 2), // Cambio al nuevo azul
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: customBlue, 
      backgroundColor: customBlue.shade100, // Color de fondo del botón
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, 
      backgroundColor: customBlue, // Color del fondo del botón
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: customBlue, // Color de la barra de navegación superior
    elevation: 4.0, // Sombra de la AppBar
    titleTextStyle: TextStyle(
      color: Colors.white, // Color del texto en la AppBar
      fontWeight: FontWeight.bold,
      fontSize: 20.0,
    ),
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      foregroundColor: Colors.red, // Color del icono de eliminar
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[100], // Color de fondo general
);

extension on Color {
  get shade100 => null;
}

