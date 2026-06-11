import 'package:flutter/material.dart';
import '../models/motorista.dart';

class CartaoMotorista extends StatelessWidget {
  final Motorista motorista;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const CartaoMotorista({
    super.key,
    required this.motorista,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            motorista.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          motorista.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('CPF: ${motorista.cpf}'),
            Text('Carteira: ${motorista.licenseNumber}'),
          ],
        ),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Text('Deletar'),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
