import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_access_object.dart';
import '../models/motorista.dart';

class TelaFormularioMotorista extends StatefulWidget {
  final Motorista? motorista;

  const TelaFormularioMotorista({super.key, this.motorista});

  @override
  State<TelaFormularioMotorista> createState() => _TelaFormularioMotoristaState();
}

class _TelaFormularioMotoristaState extends State<TelaFormularioMotorista> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController telefoneController;
  late TextEditingController observacaoController;

  String categoriaCnh = 'B';
  DateTime validadeCnh = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.motorista?.nome ?? '');
    telefoneController =
        TextEditingController(text: widget.motorista?.telefone ?? '');
    observacaoController =
        TextEditingController(text: widget.motorista?.observacao ?? '');
    categoriaCnh = widget.motorista?.categoriaCnh ?? 'B';
    validadeCnh =
        widget.motorista?.validadeCnh ?? DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    observacaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: validadeCnh,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (data != null) {
      setState(() {
        validadeCnh = data;
      });
    }
  }

  Future<void> _salvarMotorista() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final motorista = Motorista(
      id: widget.motorista?.id,
      nome: nomeController.text,
      telefone: telefoneController.text,
      categoriaCnh: categoriaCnh,
      validadeCnh: validadeCnh,
      observacao: observacaoController.text.isEmpty
          ? 'Sem observação'
          : observacaoController.text,
      createdAt: widget.motorista?.createdAt ?? DateTime.now(),
    );

    if (widget.motorista == null) {
      await DataAccessObject.incluirMotorista(motorista);
    } else {
      await DataAccessObject.alterarMotorista(motorista);
    }

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.motorista == null ? 'Novo motorista' : 'Editar motorista'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Telefone',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Preencha o telefone.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: categoriaCnh,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Categoria da CNH',
                ),
                items: const ['A', 'B', 'C', 'D', 'E']
                    .map((categoria) => DropdownMenuItem(
                          value: categoria,
                          child: Text(categoria),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      categoriaCnh = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selecionarData,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Validade da CNH',
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(validadeCnh)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: observacaoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Observação',
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _salvarMotorista,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
