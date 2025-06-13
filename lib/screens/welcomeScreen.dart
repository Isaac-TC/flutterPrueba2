import 'package:flutter/material.dart';
import 'package:prueba_2/screens/depositoScreen.dart';
import 'package:prueba_2/screens/trasferenciaScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<Widget> _pantallas = const [
    TransferScreen(),
    DepositScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Banco App")),
      body: _pantallas[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (int newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Transferencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Depósitos',
          ),
        ],
      ),
    );
  }
}
