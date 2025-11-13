class Profissional {
  int? id;
  int idEmpresa;
  String nome;
  String? foto;
  int ativo;
  String email;

  Profissional({
    this.id,
    required this.idEmpresa,
    required this.nome,
    this.foto,
    this.ativo = 1,
    this.email = '',
  });

  factory Profissional.fromJson(Map<String, dynamic> json) => Profissional(
        id: json['id'],
        idEmpresa: json['idEmpresa'],
        nome: json['nome'],
        foto: json['foto'],
        ativo: json['ativo'],
        email: json['email'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'idEmpresa': idEmpresa,
        'nome': nome,
        'foto': foto,
        'ativo': ativo,
        'email': email,
      };
}