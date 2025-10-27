import 'package:flutter/foundation.dart';

class EmpresaProvider extends ChangeNotifier {
  //final List<Empresa> _empresas = [];

  //List<Empresa> get empresas => List.unmodifiable(_empresas);

  /*Future<void> carregarEmpresas() async {
    _empresas.clear();
    _empresas.addAll(await EmpresaService().listarEmpresas());
    notifyListeners();
  }*/

  Future<void> adicionarEmpresa() async {

    notifyListeners();
  }
}
