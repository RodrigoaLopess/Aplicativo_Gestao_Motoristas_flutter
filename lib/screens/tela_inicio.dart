import 'package:flutter/material.dart';

import '../data_access_object.dart';
import '../models/motorista.dart';
import '../widgets/menu_gaveta.dart';
import 'tela_lista_motoristas.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> {
  int _abaSelecionada = 0;
  List<Motorista> _motoristas = [];

  @override
  void initState() {
    super.initState();
    _atualizarResumo();
  }

  Future<void> _atualizarResumo() async {
    final motoristas = await DataAccessObject.obterMotoristas();
    if (!mounted) {
      return;
    }
    setState(() {
      _motoristas = motoristas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Projeto Motoristas')),
      drawer: MenuGaveta(
        onInicio: () => setState(() => _abaSelecionada = 0),
        onMotoristas: () => setState(() => _abaSelecionada = 1),
        onSobre: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aplicativo Flutter com SQLite local.')),
          );
        },
      ),
      body: _abaSelecionada == 0
          ? _buildResumo()
          : TelaListaMotoristas(onAtualizar: _atualizarResumo),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _abaSelecionada,
        onTap: (index) {
          setState(() {
            _abaSelecionada = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Motoristas',
          ),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Motoristas cadastrados'),
              trailing: Text(
                _motoristas.length.toString(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Últimos nomes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _motoristas.isEmpty
                ? const Center(child: Text('Nenhum motorista cadastrado.'))
                : ListView(
                    children: _motoristas.take(3).map((motorista) {
                      return Card(
                        child: ListTile(
                          title: Text(motorista.nome),
                          subtitle: Text('Categoria ${motorista.categoriaCnh}'),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
