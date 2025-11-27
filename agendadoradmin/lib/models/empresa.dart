
import 'empresa_endereco.dart';

class Empresa {
  final int id;
  final String nome;
  final String cpfCnpj;
  final String foto;
  final int ativo;
  final String whatsApp;
  EmpresaEndereco endereco;
  final int idUsuario;

  // Construtor da classe
  Empresa({
    required this.id,
    required this.nome,
    required this.cpfCnpj,
    required this.foto,
    this.ativo = 1,
    required this.whatsApp,
    required this.endereco,
    required this.idUsuario
  });

  factory Empresa.fromJson(Map<String, dynamic> json) {
    Empresa empresa = Empresa(
      id: json['id'] ?? 0,
      nome: json['nome'],
      cpfCnpj: json['cpfCnpj'],
      foto: json['foto'] ?? '',
      ativo: json['ativo'] ?? 1,
      whatsApp: json['whatsApp'] ?? '',
      endereco: EmpresaEndereco.fromJson(json['endereco']?? json),
      idUsuario: json['idUsuario'] ?? 0,
    );
    if ((json['endereco'] == null) && (json['enderecoRua'] != null)){
      empresa.endereco.bairro = json['enderecoBairro'] ?? '';
      empresa.endereco.cidade = json['enderecoCidade'] ?? '';
      empresa.endereco.rua = json['enderecoRua'] ?? '';
      empresa.endereco.cep = json['enderecoCep'] ?? '';
      empresa.endereco.numero = json['enderecoNumero'] ?? '';
    }
    
    return empresa;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpfCnpj': cpfCnpj,
      'foto': foto,
      'ativo': ativo,
      'whatsApp': whatsApp,
      'endereco': endereco.toJson(),
      'idUsuario': idUsuario
    };
  }
}
