import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/motorista.dart';
import 'tela_formulario_motorista.dart';

class TelaDetalhesMotorista extends StatefulWidget {
  final Motorista motorista;

  const TelaDetalhesMotorista({
    super.key,
    required this.motorista,
  });

  @override
  State<TelaDetalhesMotorista> createState() => _TelaDetalhesMotoristaState();
}

class _TelaDetalhesMotoristaState extends State<TelaDetalhesMotorista>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _editMotorista() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TelaFormularioMotorista(motorista: widget.motorista),
      ),
    );

    if (result == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Motorista'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Principal com Avatar
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.blue,
                        child: Text(
                          widget.motorista.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.motorista.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Categoria ${widget.motorista.licenseCategory}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Seção Informações Pessoais
              _buildSection(
                title: 'Informações Pessoais',
                children: [
                  _buildDetailRow('CPF', widget.motorista.cpf, Icons.credit_card),
                  _buildDetailRow('Telefone', widget.motorista.phone, Icons.phone),
                  _buildDetailRow('Email', widget.motorista.email, Icons.email),
                ],
              ),
              const SizedBox(height: 16),
              // Seção Carteira de Motorista
              _buildSection(
                title: 'Carteira de Motorista',
                children: [
                  _buildDetailRow(
                    'Número',
                    widget.motorista.licenseNumber,
                    Icons.badge,
                  ),
                  _buildDetailRow(
                    'Vencimento',
                    DateFormat('dd/MM/yyyy')
                        .format(widget.motorista.licenseExpiryDate),
                    Icons.calendar_today,
                    valueColor: _isExpired() ? Colors.red : Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Seção Instruções
              _buildSection(
                title: 'Instruções Especiais',
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      widget.motorista.instructions,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Data de Criação
              _buildSection(
                title: 'Histórico',
                children: [
                  _buildDetailRow(
                    'Registrado em',
                    DateFormat('dd/MM/yyyy HH:mm')
                        .format(widget.motorista.createdAt),
                    Icons.history,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Botão Editar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _editMotorista,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Motorista'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isExpired() {
    return widget.motorista.licenseExpiryDate.isBefore(DateTime.now());
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
