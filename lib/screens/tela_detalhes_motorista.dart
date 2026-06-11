import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/motorista.dart';
import 'tela_formulario_motorista.dart';

class TelaDetalhesMotorista extends StatelessWidget {
  final Motorista motorista;

  const TelaDetalhesMotorista({super.key, required this.motorista});

  Future<void> _editarMotorista(BuildContext context) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFormularioMotorista(motorista: motorista),
      ),
    );

    if (resultado == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text(motorista.nome),
                subtitle: Text('Telefone: ${motorista.telefone}'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Categoria da CNH'),
                subtitle: Text(motorista.categoriaCnh),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Validade da CNH'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(motorista.validadeCnh)),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                title: const Text('Observação'),
                subtitle: Text(motorista.observacao),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _editarMotorista(context),
                child: const Text('Editar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
