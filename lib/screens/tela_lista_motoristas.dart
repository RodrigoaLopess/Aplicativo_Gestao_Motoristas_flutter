import 'package:flutter/material.dart';

import '../data_access_object.dart';
import '../models/motorista.dart';
import '../widgets/cartao_motorista.dart';
import 'tela_detalhes_motorista.dart';
import 'tela_formulario_motorista.dart';

class TelaListaMotoristas extends StatefulWidget {
  final VoidCallback? onAtualizar;

  const TelaListaMotoristas({super.key, this.onAtualizar});

  @override
  State<TelaListaMotoristas> createState() => _TelaListaMotoristasState();
}

class _TelaListaMotoristasState extends State<TelaListaMotoristas> {
  List<Motorista> _motoristas = [];

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  Future<void> _atualizarLista() async {
    final motoristasNoBanco = await DataAccessObject.obterMotoristas();
    if (!mounted) {
      return;
    }
    setState(() {
      _motoristas = motoristasNoBanco;
    });
    widget.onAtualizar?.call();
  }

  Future<void> _abrirFormulario([Motorista? motorista]) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaFormularioMotorista(motorista: motorista),
      ),
    );
    if (resultado == true) {
      _atualizarLista();
    }
  }

  Future<void> _abrirDetalhes(Motorista motorista) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TelaDetalhesMotorista(motorista: motorista),
      ),
    );
    if (resultado == true) {
      _atualizarLista();
    }
  }

  Future<void> _excluirMotorista(Motorista motorista) async {
    final resultado = await DataAccessObject.excluirMotorista(motorista);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resultado ? 'Motorista excluído com sucesso.' : 'Erro ao excluir motorista.',
        ),
      ),
    );
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _motoristas.isEmpty
          ? const Center(child: Text('Nenhum motorista cadastrado.'))
          : ListView.builder(
              itemCount: _motoristas.length,
              itemBuilder: (context, index) {
                final motorista = _motoristas[index];
                return CartaoMotorista(
                  motorista: motorista,
                  onTap: () => _abrirDetalhes(motorista),
                  onDelete: () => _excluirMotorista(motorista),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
