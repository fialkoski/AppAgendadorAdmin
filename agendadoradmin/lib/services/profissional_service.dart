import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:agendadoradmin/models/Profissional.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfissionalService {
  Future<List<Profissional>> buscarListaProfissionais() async {
    print(UsuarioSingleton.instance.usuario!.nome);
    print(EmpresaSingleton.instance.empresa!.id);
    return ApiService.buscarLista<Profissional>(
        '/api/${EmpresaSingleton.instance.empresa!.id}/profissionais', Profissional.fromJson);
  }

  Future<Profissional> buscarProfissionalPorId(int id) async {
    return ApiService.buscar<Profissional>(
        '/api/${EmpresaSingleton.instance.empresa!.id}/profissionais/$id', Profissional.fromJson);
  }

  Future<String> salvarProfissional(Profissional profissional) async {
    final response = await ApiService.post(
        '/api/${EmpresaSingleton.instance.empresa!.id}/profissionais', profissional.toJson());
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return 'Profissional salvo com sucesso!';
    } else {
      final Map<String, dynamic> data = jsonDecode(response.body);
      ErroRequisicao erro = ErroRequisicao.fromJson(data);
      return erro.mensagemFormatada();
    }
  }

  Future<String> atualizarProfissional(int id, Profissional profissional) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiService.URLBASE}/api/${EmpresaSingleton.instance.empresa!.id}/profissionais/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profissional.toJson()),
      );

      if (response.statusCode == 200) {
        return 'Profissional atualizado com sucesso!';
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        ErroRequisicao erro = ErroRequisicao.fromJson(data);
        return erro.mensagemFormatada();
      }
    } catch (e) {
      return 'Erro ao atualizar: ${e.toString()}';
    }
  }

  Future<String> excluirProfissional(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiService.URLBASE}/api/${EmpresaSingleton.instance.empresa!.id}/profissionais/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return 'Profissional excluído com sucesso!';
      } else {
        final Map<String, dynamic> data = jsonDecode(response.body);
        ErroRequisicao erro = ErroRequisicao.fromJson(data);
        return erro.mensagemFormatada();
      }
    } catch (e) {
      return 'Erro ao excluir: ${e.toString()}';
    }
  }

  Future<String> uploadImagem(Uint8List fotoBytes, String fotoNome ) async {
    debugPrint('Enviando imagem para o backend');
    final uri = Uri.parse('https://valdecverymoney.online/barbearia/UtilBarber.php');
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromBytes(
      'file', // Corresponde a $_FILES['file'] no PHP
      fotoBytes,
      filename: fotoNome ?? 'imagem.jpg',
    ));
    // Envia idEmpresa como campo
    final idEmpresa = EmpresaSingleton.instance.empresa?.id.toString() ?? '';
    request.fields['idEmpresa'] = idEmpresa;
    debugPrint('Enviando idEmpresa: $idEmpresa');

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 200 && jsonResponse['status'] == 200) {
          return  jsonResponse['caminho']; // Ex.: imagensBarbearia/123_nome.jpg

      } else {
        return jsonResponse['mensagem'];
      }
    } catch (e) {
      return e.toString();
    }
  }
}