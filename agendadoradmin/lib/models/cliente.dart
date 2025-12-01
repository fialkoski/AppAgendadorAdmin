class Cliente {
  String nome;
  String cpf;
  String telefone;

  Cliente({required this.nome, required this.cpf, required this.telefone});

// Método para converter JSON em um objeto Cliente
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nome: json['nome'],
      cpf: json['cpf'],
      telefone: json['telefone'],
    );
  }

  // Método para converter objeto Cliente em JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }
}
