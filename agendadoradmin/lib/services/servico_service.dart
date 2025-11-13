import 'dart:async';
import 'dart:convert';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';

class ServicoService {
  Future<List<Servico>> buscarListaServicos() async {
    return ApiService.buscarLista<Servico>(
      '/api/${EmpresaSingleton.instance.empresa!.id}/servicos',
      Servico.fromJson,
    );
  }

  Future<String> salvarServico(Servico servico) async {
    final response = await ApiService.post(
      '/api/${EmpresaSingleton.instance.empresa!.id}/servicos',
      servico.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Serviço salvo com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<String> atualizarServico(Servico servico) async {
    final response = await ApiService.put(
      '/api/${EmpresaSingleton.instance.empresa!.id}/servicos/${servico.id}',
      servico.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Serviço atualizado!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }
}
