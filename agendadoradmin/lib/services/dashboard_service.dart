import 'dart:async';
import 'package:agendadoradmin/models/dashboard_agendamento28dias.dart';
import 'package:agendadoradmin/models/dashboard_resumo.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';

class ProfissionalHorarioService {
  
  Future<DashboardResumo> buscarResumo(int idProfissional) async {
    return ApiService.buscar<DashboardResumo>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/dashboards/resumo',
      DashboardResumo.fromJson,
    );
  }

  Future<List<DashboardAgendamento28dias>> buscarListaAgendamentosUltimos28(int idProfissional) async {
    return ApiService.buscarLista<DashboardAgendamento28dias>(
      '/api/${ListaEmpresaSingleton.instance.empresa!.id}/dashboards/ultimos28',
      DashboardAgendamento28dias.fromJson,
    );
  }



}
