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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF1565C0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping_outlined, color: Colors.white, size: 48),
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
            leading: const Icon(Icons.home_outlined),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              onInicio();
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Motoristas'),
            onTap: () {
              Navigator.pop(context);
              onMotoristas();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
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
