import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/motorista.dart';
import '../services/servico_base_dados.dart';

class TelaFormularioMotorista extends StatefulWidget {
  final Motorista? motorista;

  const TelaFormularioMotorista({
    super.key,
    this.motorista,
  });

  @override
  State<TelaFormularioMotorista> createState() =>
      _TelaFormularioMotoristasState();
}

class _TelaFormularioMotoristasState extends State<TelaFormularioMotorista> {
  final _formKey = GlobalKey<FormState>();
  final ServicoBaseDados _servicoBaseDados = ServicoBaseDados();
  bool _isLoading = false;

  late TextEditingController _nameController;
  late TextEditingController _cpfController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _licenseNumberController;
  late TextEditingController _instructionsController;

  String _licenseCategory = 'A';
  DateTime _licenseExpiryDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.motorista?.name ?? '');
    _cpfController = TextEditingController(text: widget.motorista?.cpf ?? '');
    _phoneController = TextEditingController(text: widget.motorista?.phone ?? '');
    _emailController = TextEditingController(text: widget.motorista?.email ?? '');
    _licenseNumberController =
        TextEditingController(text: widget.motorista?.licenseNumber ?? '');
    _instructionsController =
        TextEditingController(text: widget.motorista?.instructions ?? '');
    _licenseCategory = widget.motorista?.licenseCategory ?? 'A';
    _licenseExpiryDate = widget.motorista?.licenseExpiryDate ??
        DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _licenseNumberController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _licenseExpiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && picked != _licenseExpiryDate) {
      setState(() {
        _licenseExpiryDate = picked;
      });
    }
  }

  Future<void> _saveMotorista() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final motorista = Motorista(
        id: widget.motorista?.id,
        name: _nameController.text,
        cpf: _cpfController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        licenseNumber: _licenseNumberController.text,
        licenseCategory: _licenseCategory,
        licenseExpiryDate: _licenseExpiryDate,
        instructions: _instructionsController.text,
        createdAt: widget.motorista?.createdAt ?? DateTime.now(),
      );

      if (widget.motorista == null) {
        await _servicoBaseDados.adicionarMotorista(motorista);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Motorista adicionado com sucesso')),
        );
      } else {
        await _servicoBaseDados.atualizarMotorista(motorista);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Motorista atualizado com sucesso')),
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.motorista == null ? 'Novo Motorista' : 'Editar Motorista'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nome
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        hintText: 'Digite o nome do motorista',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // CPF
                    TextFormField(
                      controller: _cpfController,
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        hintText: 'XXX.XXX.XXX-XX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.credit_card),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um CPF';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Telefone
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        hintText: '(XX) XXXXX-XXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um telefone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'email@exemplo.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email';
                        }
                        if (!value.contains('@')) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Número da Carteira
                    TextFormField(
                      controller: _licenseNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número da Carteira',
                        hintText: 'Número da CNH',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o número da carteira';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Categoria da Carteira
                    DropdownButtonFormField<String>(
                      value: _licenseCategory,
                      decoration: InputDecoration(
                        labelText: 'Categoria da Carteira',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.category),
                      ),
                      items: ['A', 'B', 'C', 'D', 'E'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _licenseCategory = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Data de Vencimento
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Data de Vencimento da Carteira',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_licenseExpiryDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Instruções
                    TextFormField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        labelText: 'Instruções Especiais',
                        hintText: 'Digite instruções ou observações',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.notes),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira instruções';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Botão Salvar
                    ElevatedButton(
                      onPressed: _saveMotorista,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Salvar',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
