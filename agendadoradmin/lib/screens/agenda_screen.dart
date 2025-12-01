import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/agenda_item.dart';
import 'package:agendadoradmin/models/cliente.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/services/agenda_service.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:agendadoradmin/services/servico_service.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/textfield_padrao.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final ServicoService servicoService = ServicoService();

  List<Profissional> profissionais = [];
  List<AgendaItem> agenda = [];
  List<Servico> servicos = [];

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
    carregarServicos();
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

  Future<void> carregarServicos() async {
    var listaServicos = await servicoService.buscarListaServicos();
    setState(() {
      servicos = listaServicos;
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
                  if (agenda.isEmpty ||
                      _carregandoAgenda ||
                      _carregandoProfissional)
                    const SizedBox(height: 48),
                  if (_carregandoAgenda || _carregandoProfissional)
                    Center(child: CircularProgressIndicator()),
                  if (agenda.isEmpty &&
                      (!_carregandoAgenda) &&
                      (!_carregandoProfissional))
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
                                  onSelected: (value) async {
                                    if (value == 'agendar') {
                                      final resultado =
                                          await mostrarDialogAgendarHorario(
                                            context,
                                            item,
                                            servicos,
                                          );

                                      if (resultado != null) {
                                        carregarAgenda();
                                      }
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'agendar',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.event_available,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Agendar'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'cancelar',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Cancelar'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'bloquear',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.lock,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Bloaquear horário'),
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

  Future<bool?> mostrarDialogAgendarHorario(
    BuildContext context,
    AgendaItem item,
    List<Servico> servicos,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    int servicoIdSelecionado = servicos.isNotEmpty ? servicos[0].id : 0;
    final profissional = profissionais[profissionalSelecionadoIndex!];

    final TextEditingController nomeController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController telefoneController = TextEditingController();

    return showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext statefulContext, StateSetter setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título
                        Text(
                          "Agendar horário com ${profissional.nome} às ${item.hora.substring(0, 5)} ",
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Serviço',
                          style: TextStyle(
                            color: colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (servicos.isEmpty)
                          Center(
                            child: Text(
                              'Nenhum serviço disponível. Por favor, cadastre um serviço primeiro.',
                              style: TextStyle(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          )
                        else if (servicoIdSelecionado > 0)
                          DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              isExpanded: true,
                              buttonStyleData: ButtonStyleData(
                                elevation: 2,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [],
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 50,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  color: colorScheme.surface,
                                ),
                              ),
                              items: servicos.map((servico) {
                                return DropdownMenuItem<int>(
                                  value: servico.id,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        servico.descricao,
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              value: servicoIdSelecionado,
                              onChanged: (value) {
                                setDialogState(() {
                                  servicoIdSelecionado = value!;
                                });
                              },
                              selectedItemBuilder: (context) {
                                return servicos.map((servico) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        servico.descricao,
                                        style: TextStyle(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        const SizedBox(height: 12),
                        TextFieldPadrao(
                          controller: nomeController,
                          label: "Nome do cliente",
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira o nome';
                            }
                            return null;
                          },
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 12),

                        TextFieldPadrao(
                          controller: cpfController,
                          label: "CPF",
                          icon: Icons.badge,
                          inputFormatters: [UtilTexto.mascaraCpfFormatter()],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira o CPF';
                            }
                            String cpfNumeros = value.replaceAll(
                              RegExp(r'\D'),
                              '',
                            );
                            if (cpfNumeros.length != 11 ||
                                !UtilTexto.validarCPF(cpfNumeros)) {
                              return 'CPF inválido';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 12),

                        TextFieldPadrao(
                          controller: telefoneController,
                          label: "Telefone",
                          icon: Icons.phone_android,
                          inputFormatters: [
                            UtilTexto.mascaraTelefoneFormatter(),
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira o telefone';
                            }
                            if (value.length < 15) {
                              return 'Insira um telefone válido (10-11 dígitos)';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 24),
                        // BOTÕES
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 22,
                                ),
                                foregroundColor: colorScheme.onSurface
                                    .withValues(alpha: 0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!formKey.currentState!.validate())
                                        return;
                                      Cliente cliente = Cliente(
                                        nome: nomeController.text.trim(),
                                        cpf: cpfController.text.trim(),
                                        telefone: telefoneController.text
                                            .trim(),
                                      );
                                      setDialogState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        try {
                                          await agendaService
                                              .salvarAgendamento(
                                                profissionais[profissionalSelecionadoIndex!]
                                                        .id ??
                                                    0,
                                                item.data,
                                                item.hora,
                                                servicoIdSelecionado, 
                                                cliente,
                                              )
                                              .then((resultado) {
                                                if (!mounted) return;
                                                Navigator.of(
                                                  dialogContext,
                                                ).pop(true);
                                              });
                                        } catch (e) {
                                          if (!mounted) return;
                                          UtilMensagem.showErro(
                                            context,
                                            "Falha ao realizar agendamento: $e",
                                          );
                                        }
                                      } finally {
                                        setDialogState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 22,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 3,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: colorScheme.onPrimary,
                                      ),
                                    )
                                  : const Text(
                                      'Salvar',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
