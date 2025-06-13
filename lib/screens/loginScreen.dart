import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prueba_2/screens/welcomeScreen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: formularioLogin(context),
    );
  }
}

Widget formularioLogin(BuildContext context) {
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
              login(_correo.text.trim(), _contrasenia.text.trim(), context),
          child: Text("Iniciar Sesión"),
        )
      ],
    ),
  );
}

void login(String correo, String contrasenia, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: correo, password: contrasenia);
   // ScaffoldMessenger.of(context)
        //.showSnackBar(SnackBar(content: Text("Bienvenido")));
    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const HomeScreen()),
);
 // Asegúrate de tener esta ruta
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
