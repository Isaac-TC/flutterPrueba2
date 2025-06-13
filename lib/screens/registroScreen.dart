import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registro con Firebase")),
      body: formularioRegistro(context),
    );
  }
}

Widget formularioRegistro(BuildContext context) {
  final TextEditingController _correo = TextEditingController();
  final TextEditingController _contrasenia = TextEditingController();

  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _correo,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: "Correo"),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _contrasenia,
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(), labelText: "Contraseña"),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () =>
              registrarse(_correo.text.trim(), _contrasenia.text.trim(), context),
          child: Text("Registrarse"),
        )
      ],
    ),
  );
}

void registrarse(String correo, String contrasenia, BuildContext context) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo, password: contrasenia);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado correctamente")));
    Navigator.pop(context);
  } catch (e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(e.toString()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cerrar"))
        ],
      ),
    );
  }
}
