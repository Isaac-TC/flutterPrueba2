// transfer_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();

  final List<Map<String, dynamic>> _transferencias = [];
  DatabaseReference? _transferRef;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _transferRef = FirebaseDatabase.instance.ref("transferencias/${currentUser.uid}");
      _cargarTransferencias();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarAlerta("Error", "No has iniciado sesión. Redirigiendo al login...");
        Navigator.pop(context);
      });
    }
  }

  void _cargarTransferencias() async {
    try {
      final snapshot = await _transferRef!.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map;
        final List<Map<String, dynamic>> lista = [];
        data.forEach((key, value) {
          lista.add({"id": value["id"], "nombre": value["nombre"], "monto": value["monto"]});
        });
        setState(() {
          _transferencias.clear();
          _transferencias.addAll(lista);
        });
      }
    } catch (e) {
      print("Error al cargar transferencias: \$e");
    }
  }

  void _guardarTransferencia() async {
    final nombre = _nombreController.text.trim();
    final monto = _montoController.text.trim();

    if (nombre.isEmpty || monto.isEmpty) {
      _mostrarAlerta("Campos obligatorios", "Por favor ingresa todos los datos.");
      return;
    }

    if (_transferRef == null) {
      _mostrarAlerta("Error", "No se puede guardar porque no hay usuario autenticado.");
      return;
    }

    final nuevaTransferencia = {
      "id": DateTime.now().millisecondsSinceEpoch.toString(),
      "nombre": nombre,
      "monto": monto
    };

    try {
      await _transferRef!.push().set(nuevaTransferencia);
      setState(() {
        _transferencias.add(nuevaTransferencia);
        _nombreController.clear();
        _montoController.clear();
      });
    } catch (e) {
      _mostrarAlerta("Error", "No se pudo guardar en Firebase: ${e.toString()}");
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text("Realizar Transferencia")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre del destinatario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Monto a transferir",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarTransferencia,
              child: const Text("Guardar Transferencia"),
            ),
            const SizedBox(height: 20),
            const Text("Transferencias Guardadas:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: _transferencias.length,
                itemBuilder: (context, index) {
                  final t = _transferencias[index];
                  return ListTile(
  leading: const Icon(Icons.receipt_long),
  title: Text("ID: ${t['id']}"),
  subtitle: Text("${t['nombre']} - \$${t['monto']}"),
);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
