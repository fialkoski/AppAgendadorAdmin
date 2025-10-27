
import 'dart:convert';

import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';

class EmpresaService {
  Future<Empresa> buscarEmpresaPorCpfcnpj(String cpfcnpj) async {
    return ApiService.buscar<Empresa>(
        '/api/empresas/cpfcnpj/$cpfcnpj', Empresa.fromJson);
  }

  Future<List<Empresa>> buscarEmpresaPorUsuario() async {
    return ApiService.buscarLista<Empresa>(
        '/api/empresas/usuario/${UsuarioSingleton.instance.usuario?.id}', Empresa.fromJson);
  }

  Future<String> salvarEmpresa(Empresa empresa) async {
    final response = await ApiService.post(
        '/api/empresas', empresa.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      Empresa novaEmpresa = Empresa.fromJson(data);
      ListaEmpresaSingleton.instance.addEmpresa(empresa);
      EmpresaSingleton.instance.setEmpresa(novaEmpresa);
      
      return 'Empresa cadastrada!';
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      return erro.mensagemFormatada();
    }
  }

}
