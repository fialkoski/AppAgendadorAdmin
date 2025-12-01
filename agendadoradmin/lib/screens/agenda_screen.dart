import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/agenda_item.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/services/agenda_service.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool _carregandoAgenda = false;
  bool _carregandoProfissional = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    carregarProfissionais();
    carregarAgenda();
  }

  Future<void> carregarProfissionais() async {
    setState(() {
      _carregandoProfissional = true;
    });

    try {
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
      setState(() {
        _carregandoProfissional = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoProfissional = false);
      UtilMensagem.showErro(context, "Falha ao buscar profissionais: $e");
    }
  }

  Future<void> carregarAgenda() async {
    int profissionalId = 0;
    if (profissionalSelecionadoIndex != null &&
        profissionais.length > profissionalSelecionadoIndex!) {
      profissionalId = profissionais[profissionalSelecionadoIndex!].id ?? 0;
    }
    setState(() {
      _carregandoAgenda = true;
    });

    try {
      var listaAgenda = await agendaService.buscarAgendaPorProfissionalDia(
        profissionalId,
        dataSelecionada,
      );
      setState(() {
        _carregandoAgenda = false;
        agenda = listaAgenda;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoAgenda = false);
      UtilMensagem.showErro(context, "Falha ao buscar agenda: $e");
    }
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
          icon: Icon(
            Icons.arrow_left,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              dataSelecionada = dataSelecionada.subtract(
                const Duration(days: 1),
              );
            });
            carregarAgenda();
          },
        ),

        // Data clicável abre calendário
        InkWell(
          onTap: () async {
            final DateTime? selecionada = await showDatePicker(
              //context: context,
              context: Navigator.of(context, rootNavigator: true).context,
              initialDate: dataSelecionada,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
              locale: Locale('pt', 'BR'),
              helpText: '',
              cancelText: 'Cancelar',
              confirmText: 'Confirmar',
            );

            if (selecionada != null) {
              setState(() => dataSelecionada = selecionada);
              carregarAgenda();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(color: Colors.black12),
            ),
            child: Text(
              "${dataSelecionada.day.toString().padLeft(2, '0')}-"
              "${dataSelecionada.month.toString().padLeft(2, '0')}-"
              "${dataSelecionada.year}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // Botão avançar dia
        IconButton(
          icon: Icon(
            Icons.arrow_right,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
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
    final theme = Theme.of(context);
    final _colorScheme = theme.colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                children: [
                  SizedBox(height: 16),
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
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: selecionado
                                    ? _colorScheme.primary
                                    : _colorScheme.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: selecionado
                                    ? null
                                    : Border.all(
                                        color: _colorScheme.outlineVariant,
                                      ),
                                boxShadow: selecionado
                                    ? [
                                        BoxShadow(
                                          color: _colorScheme.primary
                                              .withValues(alpha: 0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                p.nome,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: selecionado
                                      ? _colorScheme.onPrimary
                                      : _colorScheme.onSurface,
                                  fontWeight: selecionado
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (agenda.isEmpty || _carregandoAgenda || _carregandoProfissional)
                    const SizedBox(height: 48),
                  if (_carregandoAgenda || _carregandoProfissional)
                    Center(child: CircularProgressIndicator()),
                  if (agenda.isEmpty && (!_carregandoAgenda) && (!_carregandoProfissional))
                    Center(
                      child: Text(
                        'Nenhum agendamento para este dia.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  if (!_carregandoAgenda)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: agenda.length,
                      itemBuilder: (context, index) {
                        final item = agenda[index];

                        return Card(
                          color: themeNotifier.isDarkMode
                              ? _colorScheme.outlineVariant.withValues(
                                  alpha: 0.08,
                                )
                              : _colorScheme.surfaceContainerHighest.withValues(
                                  alpha: 0.9,
                                ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
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
