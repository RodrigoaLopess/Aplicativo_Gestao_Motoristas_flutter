import 'package:flutter/material.dart';

class MenuGaveta extends StatelessWidget {
  final VoidCallback onInicio;
  final VoidCallback onMotoristas;
  final VoidCallback onSobre;

  const MenuGaveta({
    super.key,
    required this.onInicio,
    required this.onMotoristas,
    required this.onSobre,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.directions_car,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Gestor de Motoristas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              onInicio();
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Motoristas'),
            onTap: () {
              Navigator.pop(context);
              onMotoristas();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre'),
            onTap: () {
              Navigator.pop(context);
              onSobre();
            },
          ),
        ],
      ),
    );
  }
}
