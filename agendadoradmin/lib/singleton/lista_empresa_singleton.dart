import 'dart:convert';

import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/tools/util.dart';

class ListaEmpresaSingleton {
  static final ListaEmpresaSingleton _instance =
      ListaEmpresaSingleton._internal();

  ListaEmpresaSingleton._internal();
  static ListaEmpresaSingleton get instance => _instance;

  List<Empresa> _empresas = [];

  List<Empresa> get empresas => _empresas;

  Future<void> setListaEmpresa(List<Empresa> empresas) async {
    _empresas = empresas;
    salvarListaEmpresaUsuarioLocal();
  }

  Future<void> addEmpresa(Empresa empresa) async {
    _empresas.add(empresa);

    salvarListaEmpresaUsuarioLocal();
  }

  void updateEmpresa(Empresa empresaAtualizada) {
    final index = _empresas.indexWhere((e) => e.id == empresaAtualizada.id);
    if (index != -1) {
      _empresas[index] = empresaAtualizada;
    } else {
      addEmpresa(empresaAtualizada);
    }
    salvarListaEmpresaUsuarioLocal();
  }

  Future<void> salvarListaEmpresaUsuarioLocal() async {
    final jsonList = empresas.map((e) => e.toJson()).toList();
    final jsonStringListaEmpresa = jsonEncode(jsonList);
    Util.salvaDadosLocal("listaEmpresaUsuario", jsonStringListaEmpresa);
  }

  Future<void> buscarListaEmpresaUsuarioLocal() async {
    final jsonStringListaEmpresa = await Util.buscarDadosLocal(
      "listaEmpresaUsuario",
    );

    if (jsonStringListaEmpresa.isNotEmpty) {
      final List decoded = jsonDecode(jsonStringListaEmpresa);
      List<Empresa> empresasBanco = decoded.map((e) => Empresa.fromJson(e)).toList();
      _empresas.addAll(empresasBanco);

      _selectedEmpresaId = int.tryParse(
        await Util.buscarDadosLocal("idEmpresaSelecionada"),
      );
    }
  }

  /// Limpa os dados (logout)
  Future<void> clear() async {
    _empresas = [];
    setSelectedEmpresaId(0);
    salvarListaEmpresaUsuarioLocal();
  }

  ///Empresa
  int? _selectedEmpresaId;
  int? get selectedEmpresaId => _selectedEmpresaId;

  Future<void> setSelectedEmpresaId(int id) async {
    _selectedEmpresaId = id;
    Util.salvaDadosLocal("idEmpresaSelecionada", _selectedEmpresaId.toString());
  }

  Empresa? get empresa {
    int? index = _empresas.indexWhere((e) => e.id == _selectedEmpresaId);
    return _empresas[index];
  }
}
