import 'dart:convert';
import 'package:agendadoradmin/models/erro_requisicao.dart';
import 'package:http/http.dart';

class UtilException {
  static Exception exceptionRequisicaoApi(Response response) {
    final Map<String, dynamic> data = json.decode(response.body);
    ErroRequisicao erro = ErroRequisicao.fromJson(data);
    return Exception(erro.mensagemFormatada());
  }
}
