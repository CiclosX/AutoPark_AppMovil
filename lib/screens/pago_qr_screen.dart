import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Importación esencial para QR

class PagoQrScreen extends StatefulWidget {
  final double tarifaPorHora;
  final String espacioNombre;
  final DateTime horaInicio;

  const PagoQrScreen({
    super.key,
    required this.tarifaPorHora,
    required this.espacioNombre,
    required this.horaInicio,
  });

  @override
  _PagoQrScreenState createState() => _PagoQrScreenState();
}

class _PagoQrScreenState extends State<PagoQrScreen> {
  bool _pagoRealizado = false;
  String _codigoTransaccion = '';
  late Duration _tiempoTranscurrido;
  late double _totalPagar;

  @override
  void initState() {
    super.initState();
    _generarCodigoTransaccion();
    _calcularTiempoYTarifa();
  }

  void _generarCodigoTransaccion() {
    final now = DateTime.now();
    setState(() {
      _codigoTransaccion = 'AP-${now.millisecondsSinceEpoch}';
    });
  }

  void _calcularTiempoYTarifa() {
    final ahora = DateTime.now();
    _tiempoTranscurrido = ahora.difference(widget.horaInicio);
    
    final horas = _tiempoTranscurrido.inMinutes / 60;
    final horasRedondeadas = horas.ceilToDouble();
    
    setState(() {
      _totalPagar = widget.tarifaPorHora * horasRedondeadas;
    });
  }

  void _realizarPago() {
    setState(() {
      _pagoRealizado = true;
    });
  }

  String _formatearDuracion(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pago Automático',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Información del espacio
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      widget.espacioNombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hora de entrada:'),
                        Text(formatter.format(widget.horaInicio)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hora actual:'),
                        Text(formatter.format(DateTime.now())),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tiempo transcurrido:'),
                        Text(_formatearDuracion(_tiempoTranscurrido)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Detalles de tarifa y pago
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Detalles de pago',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tarifa por hora:'),
                        Text('\$${widget.tarifaPorHora.toStringAsFixed(2)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tiempo facturado:'),
                        Text('${(_tiempoTranscurrido.inMinutes / 60).ceil()} horas'),
                      ],
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total a pagar:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${_totalPagar.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // QR Code y botones
            if (!_pagoRealizado) ...[
              const Text(
                'Escanea el código QR para pagar:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              QrImageView(
                data: 'autopark://pago?codigo=$_codigoTransaccion&total=$_totalPagar',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 15),
              Text(
                'Código: $_codigoTransaccion',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _realizarPago,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Confirmar Pago',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ] else ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              const SizedBox(height: 20),
              const Text(
                'Pago realizado con éxito!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Código de transacción: $_codigoTransaccion',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Finalizar',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}