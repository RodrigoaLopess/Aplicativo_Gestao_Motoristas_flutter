class Motorista {
  final int? id;
  final String name;
  final String cpf;
  final String phone;
  final String email;
  final String licenseNumber;
  final String licenseCategory;
  final DateTime licenseExpiryDate;
  final String instructions;
  final DateTime createdAt;

  Motorista({
    this.id,
    required this.name,
    required this.cpf,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.licenseCategory,
    required this.licenseExpiryDate,
    required this.instructions,
    required this.createdAt,
  });

  // Converter para Map para salvar no banco de dados
  Map<String, dynamic> paraMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'phone': phone,
      'email': email,
      'licenseNumber': licenseNumber,
      'licenseCategory': licenseCategory,
      'licenseExpiryDate': licenseExpiryDate.toIso8601String(),
      'instructions': instructions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Criar Motorista a partir de um Map (do banco de dados)
  factory Motorista.deMap(Map<String, dynamic> map) {
    return Motorista(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      phone: map['phone'],
      email: map['email'],
      licenseNumber: map['licenseNumber'],
      licenseCategory: map['licenseCategory'],
      licenseExpiryDate: DateTime.parse(map['licenseExpiryDate']),
      instructions: map['instructions'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Copiar com mudanças
  Motorista comAlteracoes({
    int? id,
    String? name,
    String? cpf,
    String? phone,
    String? email,
    String? licenseNumber,
    String? licenseCategory,
    DateTime? licenseExpiryDate,
    String? instructions,
    DateTime? createdAt,
  }) {
    return Motorista(
      id: id ?? this.id,
      name: name ?? this.name,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseCategory: licenseCategory ?? this.licenseCategory,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
