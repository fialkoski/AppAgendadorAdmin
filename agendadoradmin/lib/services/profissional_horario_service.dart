import 'dart:async';
import 'dart:convert';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/profissional_horario.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:http/http.dart' as http;

class ProfissionalHorarioService {
  Future<List<ProfissionalHorario>> buscarListaProfissionalHorarios(int idProfissional) async {
    return ApiService.buscarLista<ProfissionalHorario>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalhorarios/profissional/$idProfissional',
      ProfissionalHorario.fromJson,
    );
  }

  Future<String> salvarProfissionalHorario(List<ProfissionalHorario> listaProfissionalHorario) async {
    List<Map<String, dynamic>> jsonList =
    listaProfissionalHorario.map((h) => h.toJson()).toList();

    final response = await ApiService.post(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalhorarios',
      null, listJsonDados: jsonList,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Agenda salvo com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<String> deletarProfissionalHorario(List<ProfissionalHorario> listaProfissionalHorario) async {
    List<Map<String, dynamic>> jsonList =
    listaProfissionalHorario.map((h) => h.toJson()).toList();

    final response = await ApiService.delete(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalhorarios',
      null, listJsonDados: jsonList,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Agenda excluida com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<String> excluirProfissional(int id) async {
    final response = await http.delete(
      Uri.parse(
        '${ApiService.URLBASE}/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionais/$id',
      ),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return 'Profissional excluído com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

}
