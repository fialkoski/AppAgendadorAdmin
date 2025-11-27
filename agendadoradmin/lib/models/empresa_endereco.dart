class EmpresaEndereco {
  String rua;
  String numero;
  String bairro;
  String cidade;
  String cep;

  EmpresaEndereco({
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.cep,
  });

  // Método para criar um objeto Endereco a partir de um JSON
  factory EmpresaEndereco.fromJson(Map<String, dynamic> json) {
    return EmpresaEndereco(
      rua: json['rua'] ?? '',
      numero: json['numero'] ?? '',
      bairro: json['bairro'] ?? '',
      cidade: json['cidade'] ?? '',
      cep: json['cep'] ?? '',
    );
  }

  // Método para converter um objeto Endereco em JSON
  Map<String, dynamic> toJson() {
    return {
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
    };
  }

  String enderecoCompleto(){
    return '$rua, $numero, $bairro - $cidade';
  }
}
