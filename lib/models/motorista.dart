class Motorista {
  final int? id;
  final String nome;
  final String telefone;
  final String categoriaCnh;
  final DateTime validadeCnh;
  final String observacao;
  final DateTime createdAt;

  Motorista({
    this.id,
    required this.nome,
    required this.telefone,
    required this.categoriaCnh,
    required this.validadeCnh,
    required this.observacao,
    required this.createdAt,
  });

  Map<String, dynamic> paraMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'categoriaCnh': categoriaCnh,
      'validadeCnh': validadeCnh.toIso8601String(),
      'observacao': observacao,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Motorista.deMap(Map<String, dynamic> map) {
    return Motorista(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      telefone: map['telefone'] as String,
      categoriaCnh: map['categoriaCnh'] as String,
      validadeCnh: DateTime.parse(map['validadeCnh'] as String),
      observacao: map['observacao'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
