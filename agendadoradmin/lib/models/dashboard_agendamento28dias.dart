class DashboardAgendamento28dias {
  final String dia;
  final String total;

  DashboardAgendamento28dias({
    required this.dia,
    required this.total,
  });

  factory DashboardAgendamento28dias.fromJson(
      Map<String, dynamic> json) {
    return DashboardAgendamento28dias(
      dia: json['dia'] ?? '',
      total: json['total']?.toString() ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dia': dia,
      'total': total,
    };
  }
}
