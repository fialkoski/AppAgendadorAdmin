import 'dart:convert';

import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/usuario.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';

class LoginService {
  Future<String> login(Usuario usuario) async {
    final Map<String, dynamic> dados = {
      "usuario": usuario.email,
      "senha": usuario.senha,
    };

    final response = await ApiService.postSemAuth('/api/auth/token', dados);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['token'] != null && data['usuario'] != null) {
        Usuario usuarioApi = Usuario.fromJson(data['usuario']);
        await UsuarioSingleton.instance.setUsuario(usuarioApi, data['token'], data['refreshToken']);
      }
      return 'login ok!';
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      throw Exception('Falha ao realizar o login: ${erro.mensagemFormatada()}');
    }
  }
}
