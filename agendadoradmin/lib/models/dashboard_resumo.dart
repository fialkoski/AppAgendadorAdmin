class DashboardResumo {
  final int idEmpresa;
  final String agendamentosHoje;
  final String receitaHoje;
  final String clientes28Dias;
  final String agendamentos28Dias;
  final String receita28Dias;

  DashboardResumo({
    required this.idEmpresa,
    required this.agendamentosHoje,
    required this.receitaHoje,
    required this.clientes28Dias,
    required this.agendamentos28Dias,
    required this.receita28Dias,
  });

  factory DashboardResumo.fromJson(Map<String, dynamic> json) {
    return DashboardResumo(
      idEmpresa: json['idEmpresa'] ?? 0,
      agendamentosHoje: json['agendamentosHoje']?.toString() ?? '0',
      receitaHoje: json['receitaHoje']?.toString() ?? '0',
      clientes28Dias: json['clientes28Dias']?.toString() ?? '0',
      agendamentos28Dias: json['agendamentos28Dias']?.toString() ?? '0',
      receita28Dias: json['receita28Dias']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEmpresa': idEmpresa,
      'agendamentosHoje': agendamentosHoje,
      'receitaHoje': receitaHoje,
      'clientes28Dias': clientes28Dias,
      'agendamentos28Dias': agendamentos28Dias,
      'receita28Dias': receita28Dias,
    };
  }
}
