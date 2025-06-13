import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepositoScreen extends StatelessWidget {
  const DepositoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Lista de Depósitos")),
      body: lista(),
    );
  }
}

Future<List> leerApi() async {
  final respuesta = await http.get(
    Uri.parse("https://jritsqmet.github.io/web-api/depositos.json"),
  );

  if (respuesta.statusCode == 200) {
    return json.decode(respuesta.body); // ✅ ya es una lista
  } else {
    throw Exception("Sin conexión o error en la API");
  }
}

Widget lista() {
  return FutureBuilder<List>(
    future: leerApi(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return const Center(child: Text("Error al cargar datos"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No hay datos disponibles"));
      } else {
        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final detalles = item['detalles'];
            return ListTile(
              leading: Image.network(
                detalles['imagen_comprobante'] ?? '',
                width: 40,
                height: 40,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
              title: Text("Banco: ${item['banco']}"),
              subtitle: Text("Monto: \$${item['monto']}"),
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Detalle de la Transacción"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ID: ${item['id']}"),
                      Text("Fecha: ${item['fecha']}"),
                      Text("Método: ${detalles['método_pago']}"),
                      Text("Estado: ${detalles['estado']}"),
                      const SizedBox(height: 8),
                      Text("De: ${item['origen']['nombre']}"),
                      Text("Para: ${item['destino']['nombre']}"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cerrar"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  );
}
