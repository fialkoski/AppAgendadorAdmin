
class Usuario {
  final int id;
  final String nome;
  final String email;
  final String uidgoogle;
  final String senha;

  // Construtor da classe
  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.uidgoogle,
    required this.senha,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? '',
      email: json['email'],
      uidgoogle: json['uidgoogle'] ?? '',
      senha: json['senha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'uidgoogle': uidgoogle,
      'senha': senha,
    };
  }
}
