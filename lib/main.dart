
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prueba_2/firebase_options.dart';
import 'package:prueba_2/screens/loginScreen.dart';
import 'package:prueba_2/screens/registroScreen.dart';

void main() async {  
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const supaApp());
}

class supaApp extends StatelessWidget {
  const supaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home:  Cuerpo()
      
    );
  }
}

class Cuerpo extends StatelessWidget {
  const Cuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banco App")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            btnLogin(context),
            SizedBox(height: 10),
            btnRegistro(context),
          ],
        ),
      ),
    );
  }
}

Widget btnLogin(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    ),
    child: const Text("Ir a Login"),
  );
}

Widget btnRegistro(BuildContext context) {
  return ElevatedButton(
    onPressed: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Registro()),
    ),
    child: const Text("Ir a Registro"),
  );
}

