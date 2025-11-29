import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Stats {
  final int totalClients;
  final int todayAppointments;
  final double monthRevenue;
  final int activeBarbers;

  Stats({
    required this.totalClients,
    required this.todayAppointments,
    required this.monthRevenue,
    required this.activeBarbers,
  });
}

class Appointment {
  final int id;
  final String scheduledDate;
  final String scheduledTime;
  final String status;
  final String clientName;
  final String barberName;
  final String serviceName;
  final double servicePrice;

  Appointment({
    required this.id,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.clientName,
    required this.barberName,
    required this.serviceName,
    required this.servicePrice,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Stats? stats;
  List<Appointment> todayAppointments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => loading = true);

    await Future.delayed(const Duration(milliseconds: 900)); // simular API

    stats = Stats(
      totalClients: 124,
      todayAppointments: 6,
      monthRevenue: 3560.50,
      activeBarbers: 3,
    );

    todayAppointments = [
      Appointment(
        id: 1,
        scheduledDate: "2025-11-28",
        scheduledTime: "14:00",
        status: "confirmed",
        clientName: "João Silva",
        barberName: "Carlos",
        serviceName: "Corte + Barba",
        servicePrice: 65.00,
      ),
      Appointment(
        id: 2,
        scheduledDate: "2025-11-28",
        scheduledTime: "15:00",
        status: "scheduled",
        clientName: "Marcos Paulo",
        barberName: "Jorge",
        serviceName: "Sombrancelha",
        servicePrice: 25.00,
      ),
    ];

    setState(() => loading = false);
  }

  // -------- STATUS COLORS -------- //
  Color statusColor(String status, BuildContext context) {
    switch (status) {
      case "scheduled":
        return Colors.blueAccent.withOpacity(.3);
      case "confirmed":
        return Colors.greenAccent.withOpacity(.3);
      case "in_progress":
        return Colors.yellowAccent.withOpacity(.3);
      case "completed":
        return Colors.tealAccent.withOpacity(.3);
      case "cancelled":
        return Colors.redAccent.withOpacity(.3);
      case "no_show":
        return Colors.grey.withOpacity(.3);
      default:
        return Colors.grey.withOpacity(.3);
    }
  }

  String statusLabel(String status) {
    switch (status) {
      case "scheduled":
        return "Agendado";
      case "confirmed":
        return "Confirmado";
      case "in_progress":
        return "Em andamento";
      case "completed":
        return "Concluído";
      case "cancelled":
        return "Cancelado";
      case "no_show":
        return "Faltou";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat("dd 'de' MMMM, yyyy", 'pt_BR').format(DateTime.now());

    final statCards = [
      {
        'title': "Total de Clientes",
        'value': stats?.totalClients ?? 0,
        'icon': Icons.people,
      },
      {
        'title': "Agendamentos Hoje",
        'value': stats?.todayAppointments ?? 0,
        'icon': Icons.calendar_month,
      },
      {
        'title': "Receita do Mês",
        'value': "R\$ ${stats?.monthRevenue.toStringAsFixed(2) ?? '0.00'}",
        'icon': Icons.attach_money,
      },
      {
        'title': "Barbeiros Ativos",
        'value': stats?.activeBarbers ?? 0,
        'icon': Icons.cut,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dashboard",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Bem-vindo!",
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(.1)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.trending_up, color: Colors.greenAccent, size: 20),
                        const SizedBox(width: 8),
                        Text(dateFormatted),
                      ],
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // -------- STATS CARDS --------
              loading
                  ? GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      children: List.generate(
                        4,
                        (i) => Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(.08),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.4,
                      children: statCards.map((stat) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(.05),
                            border: Border.all(color: Colors.white.withOpacity(.08)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(stat['icon'] as IconData, size: 32, color: Colors.white),
                              const SizedBox(height: 12),
                              Text(
                                stat['title'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white54),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${stat['value']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

              const SizedBox(height: 28),

              // -------- APPOINTMENTS --------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(.05),
                  border: Border.all(color: Colors.white.withOpacity(.08)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.purpleAccent.withOpacity(.2),
                              ),
                              child: const Icon(Icons.schedule, color: Colors.purpleAccent),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Agendamentos de Hoje",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text("Ver Todos"),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    loading
                        ? const Center(child: CircularProgressIndicator())
                        : todayAppointments.isEmpty
                            ? Column(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 60, color: Colors.grey),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Nenhum agendamento para hoje",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!.copyWith(
                                              color: Colors.grey,
                                            ),
                                  ),
                                ],
                              )
                            : Column(
                                children: todayAppointments.map((a) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white.withOpacity(.05),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(.08)),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    a.clientName,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(10),
                                                      color: statusColor(a.status, context),
                                                    ),
                                                    child: Text(
                                                      statusLabel(a.status),
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "${a.serviceName} • ${a.barberName}",
                                                style: TextStyle(
                                                    color: Colors.white.withOpacity(.6)),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(a.scheduledTime,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500)),
                                            Text(
                                              "R\$ ${a.servicePrice.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color:
                                                      Colors.white.withOpacity(.6)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }).toList(),
                              )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
