import 'dart:convert';

import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/usuario.dart';
import 'package:agendadoradmin/services/api_service.dart';

class UsuarioService {

Future<String> salvarUsuario(Usuario usuario) async {
    final response = await ApiService.postSemAuth(
        '/api/usuarios/cadastrar', usuario.toJson());
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Usuário cadastrado!';
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      throw Exception('Falha ao cadastrar: ${erro.mensagemFormatada()}');
    }
  }

}