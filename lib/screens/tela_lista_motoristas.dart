import 'package:flutter/material.dart';
import '../models/motorista.dart';
import '../services/servico_base_dados.dart';
import '../widgets/cartao_motorista.dart';
import 'tela_formulario_motorista.dart';
import 'tela_detalhes_motorista.dart';

class TelaListaMotoristas extends StatefulWidget {
  final VoidCallback? onMotoristaUpdated;

  const TelaListaMotoristas({
    super.key,
    this.onMotoristaUpdated,
  });

  @override
  State<TelaListaMotoristas> createState() => _TelaListaMotoristasState();
}

class _TelaListaMotoristasState extends State<TelaListaMotoristas> {
  final ServicoBaseDados _servicoBaseDados = ServicoBaseDados();
  List<Motorista> _motoristas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarMotoristas();
  }

  Future<void> _carregarMotoristas() async {
    setState(() => _isLoading = true);
    final motoristas = await _servicoBaseDados.obterTodosMotoristas();
    setState(() {
      _motoristas = motoristas;
      _isLoading = false;
    });
    widget.onMotoristaUpdated?.call();
  }

  void _navigateToForm({Motorista? motorista}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFormularioMotorista(motorista: motorista),
      ),
    );

    if (result == true) {
      _carregarMotoristas();
    }
  }

  void _navigateToDetails(Motorista motorista) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesMotorista(motorista: motorista),
      ),
    );
  }

  void _deleteMotorista(Motorista motorista) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja excluir ${motorista.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _servicoBaseDados.deletarMotorista(motorista.id!);
                Navigator.pop(context);
                _carregarMotoristas();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Motorista excluído com sucesso')),
                );
              },
              child: const Text('Excluir', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Motoristas'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _motoristas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_outline, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('Nenhum motorista registrado'),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _navigateToForm(),
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Motorista'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _motoristas.length,
                  itemBuilder: (context, index) {
                    final motorista = _motoristas[index];
                    return CartaoMotorista(
                      motorista: motorista,
                      onTap: () => _navigateToDetails(motorista),
                      onDelete: () => _deleteMotorista(motorista),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
