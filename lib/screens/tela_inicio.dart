import 'package:flutter/material.dart';
import '../models/motorista.dart';
import '../services/servico_base_dados.dart';
import '../widgets/menu_gaveta.dart';
import 'tela_lista_motoristas.dart';

class TelaInicio extends StatefulWidget {
  const TelaInicio({super.key});

  @override
  State<TelaInicio> createState() => _TelaInicioState();
}

class _TelaInicioState extends State<TelaInicio> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final ServicoBaseDados _servicoBaseDados = ServicoBaseDados();
  List<Motorista> _motoristas = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _carregarMotoristas();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _carregarMotoristas() async {
    final motoristas = await _servicoBaseDados.obterTodosMotoristas();
    setState(() {
      _motoristas = motoristas;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onNavigateToMotoristas() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestor de Motoristas'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      drawer: MenuGaveta(
        onInicio: () => _onItemTapped(0),
        onMotoristas: _onNavigateToMotoristas,
        onSobre: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aplicativo de Gestão de Motoristas v1.0'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildOverviewScreen(),
          TelaListaMotoristas(onMotoristaUpdated: _carregarMotoristas),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Visão Geral',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Motoristas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildOverviewScreen() {
    return FadeTransition(
      opacity: _animationController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card de Estatísticas
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estatísticas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatistic('Motoristas', _motoristas.length.toString()),
                        _buildStatistic(
                          'Registrados Hoje',
                          _getMotoristaCountHoje().toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Últimos Motoristas Registrados
            const Text(
              'Últimos Registros',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (_motoristas.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nenhum motorista registrado ainda'),
              )
            else
              ..._motoristas.take(3).map((motorista) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        motorista.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(motorista.name),
                    subtitle: Text(motorista.cpf),
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  int _getMotoristaCountHoje() {
    final hoje = DateTime.now();
    return _motoristas.where((motorista) {
      return motorista.createdAt.year == hoje.year &&
          motorista.createdAt.month == hoje.month &&
          motorista.createdAt.day == hoje.day;
    }).length;
  }
}
