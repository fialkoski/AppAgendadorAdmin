import 'package:agendadoradmin/models/agenda_item.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/services/agenda_service.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:flutter/material.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final ProfissionalService profissionalService = ProfissionalService();
  final AgendaService agendaService = AgendaService();

  List<Profissional> profissionais = [];
  List<AgendaItem> agenda = [];

  DateTime dataSelecionada = DateTime.now();
  int? profissionalSelecionadoIndex;

  @override
  void initState() {
    super.initState();
    carregarProfissionais();
    carregarAgenda();
  }

  Future<void> carregarProfissionais() async {
    var listaProfissionais = await profissionalService
        .buscarListaProfissionais();
    setState(() {
      profissionais = listaProfissionais;
      if (profissionais.isNotEmpty) {
        profissionalSelecionadoIndex = 0;
      }
    });
    if (profissionais.isNotEmpty) {
      await carregarAgenda();
    }
  }

  Future<void> carregarAgenda() async {
    int profissionalId = 0;
    if (profissionalSelecionadoIndex != null &&
        profissionais.length > profissionalSelecionadoIndex!) {
      profissionalId = profissionais[profissionalSelecionadoIndex!].id ?? 0;
    }

    var listaAgenda = await agendaService.buscarAgendaPorProfissionalDia(
      profissionalId,
      dataSelecionada,
    );
    setState(() {
      agenda = listaAgenda;
    });
  }

  void mudarDia(int incremento) {
    setState(() {
      dataSelecionada = dataSelecionada.add(Duration(days: incremento));
    });
    carregarAgenda();
  }

  Widget seletorData(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Botão voltar dia
      IconButton(
        icon: Icon(Icons.arrow_left, size: 40,color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          setState(() {
            dataSelecionada = dataSelecionada.subtract(const Duration(days: 1));
          });
          carregarAgenda();
        },
      ),

      // Data clicável abre calendário
      InkWell(
        onTap: () async {
          final DateTime? selecionada = await showDatePicker(
            context: context,
            initialDate: dataSelecionada,
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );

          if (selecionada != null) {
            setState(() => dataSelecionada = selecionada);
            carregarAgenda();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${dataSelecionada.day.toString().padLeft(2, '0')}-"
            "${dataSelecionada.month.toString().padLeft(2, '0')}-"
            "${dataSelecionada.year}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // Botão avançar dia
      IconButton(
        icon: Icon(Icons.arrow_right, size: 40, color: Theme.of(context).colorScheme.primary),
        onPressed: () {
          setState(() {
            dataSelecionada = dataSelecionada.add(const Duration(days: 1));
          });
          carregarAgenda();
        },
      ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  seletorData(context),
                  // Barra de barbeiros
                  SizedBox(
                    height: 80,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: profissionais.asMap().entries.map((entry) {
                          int index = entry.key;
                          final p = entry.value;
                          bool selecionado =
                              profissionalSelecionadoIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(
                                () => profissionalSelecionadoIndex = index,
                              );
                              carregarAgenda();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selecionado
                                    ? Colors.white
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                p.nome,
                                style: TextStyle(
                                  color: selecionado
                                      ? Colors.black
                                      : Colors.grey.shade600,
                                  fontWeight: selecionado
                                      ? FontWeight.bold
                                      : FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: agenda.length,
                    itemBuilder: (context, index) {
                      final item = agenda[index];

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${item.hora.substring(0, 5)}  ${item.nomeCliente == '' ? "Livre" : item.nomeCliente}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                                onSelected: (value) {
                                  if (value == 'remover') {}
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'remover',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Remover'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
