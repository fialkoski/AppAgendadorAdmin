import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/models/profissional_servico.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfissionalService {
  Future<List<Profissional>> buscarListaProfissionais() async {
    return ApiService.buscarLista<Profissional>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionais',
      Profissional.fromJson,
    );
  }

  Future<Profissional> buscarProfissionalPorId(int id) async {
    return ApiService.buscar<Profissional>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionais/$id',
      Profissional.fromJson,
    );
  }

  Future<Profissional> salvarProfissional(Profissional profissional) async {
    final response = await ApiService.post(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionais',
      profissional.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Profissional.fromJson(jsonDecode(response.body));
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<Profissional> atualizarProfissional(Profissional profissional) async {
    final response = await ApiService.put(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionais/${profissional.id}',
      profissional.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Profissional.fromJson(jsonDecode(response.body));
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

  Future<String> uploadImagem(Uint8List fotoBytes, String fotoNome) async {
    debugPrint('Enviando imagem para o backend');
    final uri = Uri.parse(
      'https://valdecverymoney.online/barbearia/UtilBarber.php',
    );
    final request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file', // Corresponde a $_FILES['file'] no PHP
        fotoBytes,
        filename: fotoNome,
      ),
    );
    // Envia idEmpresa como campo
    final idEmpresa = ListaEmpresaSingleton.instance.empresa?.id.toString() ?? '';
    request.fields['idEmpresa'] = idEmpresa;
    debugPrint('Enviando idEmpresa: $idEmpresa');

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['status'] == 200) {
        return jsonResponse['caminho']; // Ex.: imagensBarbearia/123_nome.jpg
      } else {
        return jsonResponse['mensagem'];
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<ProfissionalServico>> buscarListaProfissionalServicos(int idProfissional) async {
    return ApiService.buscarLista<ProfissionalServico>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalservicos/profissional/$idProfissional',
      ProfissionalServico.fromJson,
    );
  }

  Future<String> salvarProfissionalServico(List<ProfissionalServico> listaProfissionalServico) async {
    List<Map<String, dynamic>> jsonList =
    listaProfissionalServico.map((h) => h.toJson()).toList();

    final response = await ApiService.post(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalservicos',
      null, listJsonDados: jsonList,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Serviços salvo com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

  Future<String> deletarProfissionalServico(List<ProfissionalServico> listaProfissionalServico) async {
    List<Map<String, dynamic>> jsonList =
    listaProfissionalServico.map((h) => h.toJson()).toList();

    final response = await ApiService.delete(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/profissionalservicos',
      null, listJsonDados: jsonList,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Serviços excluidos com sucesso!';
    } else {
      ErroRequisicao erro = ErroRequisicao.fromJson(jsonDecode(response.body));
      throw Exception(erro.mensagemFormatada().replaceFirst('Exception: ', ''));
    }
  }

}
