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
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(motorista.nome),
        subtitle: Text('Telefone: ${motorista.telefone}'),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete),
        ),
        onTap: onTap,
      ),
    );
  }
}
