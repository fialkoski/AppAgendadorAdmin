import 'dart:async';
import 'dart:convert';
import 'package:agendadoradmin/models/agenda_item.dart';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';

class AgendaService {

  Future<List<AgendaItem>> buscarAgendaPorProfissionalDia(
    int idProfissional,
    DateTime dataSelecionada,
  ) async {
    if (ListaEmpresaSingleton.instance.empresa == null) return [];
    
    String formatada =
        "${dataSelecionada.year.toString().padLeft(4, '0')}-"
        "${dataSelecionada.month.toString().padLeft(2, '0')}-"
        "${dataSelecionada.day.toString().padLeft(2, '0')}";

    final buscaJson = {"idProfissional": idProfissional, "dia": formatada};

    final response = await ApiService.post(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/agendas/profissional/dia',
      buscaJson,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AgendaItem.fromJson(json)).toList();
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<List<AgendaItem>> buscarAgendaPorProfissionalPeriodo(
    int idProfissional,
    DateTime dataInicial,
    DateTime dataFinal,
  ) async {
    String formatadaInicial =
        "${dataInicial.year.toString().padLeft(4, '0')}-"
        "${dataInicial.month.toString().padLeft(2, '0')}-"
        "${dataInicial.day.toString().padLeft(2, '0')}";

    String formatadaFinal =
        "${dataFinal.year.toString().padLeft(4, '0')}-"
        "${dataFinal.month.toString().padLeft(2, '0')}-"
        "${dataFinal.day.toString().padLeft(2, '0')}";    

    final buscaJson = {"idProfissional": idProfissional, "dataInicial": formatadaInicial, "dataFinal": formatadaFinal};

    final response = await ApiService.post(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/agendas/profissional/periodo',
      buscaJson,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AgendaItem.fromJson(json)).toList();
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

}
