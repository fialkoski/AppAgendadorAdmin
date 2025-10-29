import 'dart:async';
import 'dart:convert';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:agendadoradmin/tools/util_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  static String URLBASE =
         'https://agendador-fzghg9hrh9bgb9dm.canadacentral-01.azurewebsites.net';
      //'http://localhost:8080';
  static String URLBASEIMG = 'https://valdecverymoney.online/barbearia/';

  static void Function()? onRedirecionamento;

  static Future<T> buscar<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.get(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Authorization': 'Bearer $meuToken',
        },
      ).timeout(Duration(seconds: 20));

      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return fromJson(data);
      } else {
        throw UtilException.exceptionRequisicaoApi(response);
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao buscar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<List<T>> buscarLista<T>(
      String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.get(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Authorization': 'Bearer $meuToken',
        },
      ).timeout(Duration(seconds: 15));
      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => fromJson(json)).toList();
      } else {
        throw UtilException.exceptionRequisicaoApi(response);
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao buscar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<Response> post(
      String url, Map<String, dynamic> jsonDados) async {
    try {
      final meuToken = await buscarToken();
      final response = await http.post(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $meuToken',
        },
        body: json.encode(jsonDados),
      );

      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      return response;
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao enviar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<Response> put(
      String url, Map<String, dynamic> jsonDados) async {
    try {
      final response = await http.put(
        Uri.parse('$URLBASE$url'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonDados),
      );
      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      return response;
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      throw Exception(
          'Falha ao enviar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<Response> delete(String url) async {
    try {
      final response = await http.delete(Uri.parse('$URLBASE$url'));
      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      return response;
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } catch (e) {
      throw Exception(
          'Falha ao excluir dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<Response> postSemAuth(
      String url, Map<String, dynamic> jsonDados) async {
    try {
      final response = await http.post(
        Uri.parse('$URLBASE$url'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonDados),
      );

      print(
          'Requisição:$URLBASE$url\nHTTP:${response.statusCode}\nJSON retornado: ${response.body}');
      return response;
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } on FormatException catch (e) {
      throw Exception('Erro ao formatar os dados: ${e.message}');
    } catch (e) {
      print('Erro post Sem Auth:${e.toString()}');
      throw Exception(
          'Falha ao enviar dados: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  static Future<String> buscarToken() async {
    var meuToken = UsuarioSingleton.instance.token ?? '';
    DateTime nowUtcMinus3 = DateTime.now().toUtc();
    DateTime? expiration =
        getJwtExpiration(meuToken)?.subtract(const Duration(hours: 4));
    if (expiration == null || nowUtcMinus3.isAfter(expiration)) {
      meuToken = await postRefreshToken();
    } 
    return meuToken;
  }

  static Future<String> postRefreshToken() async {
    final meuToken = UsuarioSingleton.instance.refreshtoken;
    if (meuToken == null || meuToken.isEmpty) {
      onRedirecionamento?.call();
      return '';
    }

    final Map<String, dynamic> dados = {
      "refreshToken": meuToken,
    };

    try {
      final response = await http.post(
        Uri.parse('$URLBASE/api/auth/refreshtoken'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $meuToken',
        },
        body: json.encode(dados),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['token'] != null && data['refreshToken'] != null) {
          await UsuarioSingleton.instance.setUsuario(
              UsuarioSingleton.instance.usuario!,
              data['token'],
              data['refreshToken']);
        }
        return UsuarioSingleton.instance.token!;
      } else {
        onRedirecionamento?.call();
        return '';
      }
    } on TimeoutException {
      throw Exception('A solicitação excedeu o tempo limite');
    } catch (e) {
      onRedirecionamento?.call();
      return '';
    }
  }

  static DateTime? getJwtExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      String normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);

      if (payloadMap is! Map<String, dynamic>) return null;
      if (!payloadMap.containsKey('exp')) return null;

      final exp = payloadMap['exp'];
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true);
    } catch (e) {
      return null;
    }
  }
}
