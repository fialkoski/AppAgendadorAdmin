import 'dart:convert';
import 'package:agendadoradmin/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UsuarioSingleton {
  static final UsuarioSingleton _instance = UsuarioSingleton._internal();
  static const _storage = FlutterSecureStorage();

  Usuario? _usuario;
  String? _token;
  String? _refreshtoken;

  UsuarioSingleton._internal();

  static UsuarioSingleton get instance => _instance;

  Usuario? get usuario => _usuario;
  String? get token => _token;
  String? get refreshtoken => _refreshtoken;

  /// Define o usuário atual e salva localmente
  Future<void> setUsuario(Usuario usuario, String token, String refreshtoken) async {
    _usuario = usuario;
    _token = token;
    _refreshtoken = refreshtoken;
    await _storage.write(key: 'usuario', value: jsonEncode(usuario.toJson()));
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'refreshtoken', value: refreshtoken);
  }

  /// Carrega o usuário salvo (chamar no início do app)
  Future<void> carregarUsuario() async {
    final usuarioStr = await _storage.read(key: 'usuario');
    final tokenStr = await _storage.read(key: 'token');
    final refreshtokenStr = await _storage.read(key: 'refreshtoken');

    if (usuarioStr != null && tokenStr != null) {
      final json = jsonDecode(usuarioStr);
      _usuario = Usuario.fromJson(json);
      _token = tokenStr;
      _refreshtoken = refreshtokenStr;
    }
  }

  /// Limpa os dados (logout)
  Future<void> clear() async {
    _usuario = null;
    _token = null;
    _refreshtoken = null;
    await _storage.delete(key: 'usuario');
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'refreshtoken');
  }

  bool tokenValido(){
    if (_token == null || _token!.isEmpty) {
      return false;
    } 
    return true;
  }
}
