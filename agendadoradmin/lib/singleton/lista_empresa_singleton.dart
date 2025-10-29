import 'package:agendadoradmin/models/empresa.dart';

class ListaEmpresaSingleton {
  static final ListaEmpresaSingleton _instance =
      ListaEmpresaSingleton._internal();

  List<Empresa>? _empresas;

  ListaEmpresaSingleton._internal();

  static ListaEmpresaSingleton get instance => _instance;

  List<Empresa>? get empresas => _empresas;

  /// Define o usuário atual e salva localmente
  Future<void> setListaEmpresa(List<Empresa> empresas) async {
    _empresas = empresas;
  }

  Future<void> addEmpresa(Empresa empresa) async {
    if (_empresas == null) {
      _empresas = List.empty();
    } else {
      _empresas!.add(empresa);
    }
  }

  void updateEmpresa(Empresa empresaAtualizada) {
    _empresas ??= List.empty();
    final index = _empresas!.indexWhere((e) => e.id == empresaAtualizada.id);
    if (index != -1) {
      _empresas![index] = empresaAtualizada;
    } else {
      addEmpresa(empresaAtualizada);
    }
  }

  /// Limpa os dados (logout)
  Future<void> clear() async {
    _empresas = null;
  }
}
