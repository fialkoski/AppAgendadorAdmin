
import 'package:agendadoradmin/models/empresa.dart';

class EmpresaSingleton {
  static final EmpresaSingleton _instance = EmpresaSingleton._internal();

  EmpresaSingleton._internal();

  static EmpresaSingleton get instance => _instance;

  Empresa? _empresa;
  int? _selectedEmpresaId;

  Empresa? get empresa => _empresa;
  int? get selectedEmpresaId => _selectedEmpresaId;

  /// Define o usuário atual e salva localmente
  Future<void> setEmpresa(Empresa empresa) async {
    _empresa = empresa;
    _selectedEmpresaId = _empresa!.id;
  }

  /// Define o usuário atual e salva localmente
  Future<void> setSelectedEmpresaId(int id) async {
    _selectedEmpresaId = id;
  }

  /// Limpa os dados (logout)
  Future<void> clear() async {
    _empresa = null;
  }
}

