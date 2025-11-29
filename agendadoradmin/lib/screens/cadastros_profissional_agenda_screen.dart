import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/models/profissional_horario.dart';
import 'package:agendadoradmin/services/profissional_horario_service.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/button_bar_padrao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CadastroProfissionalAgendaScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  final Profissional? profissionalEdicao;

  const CadastroProfissionalAgendaScreen({
    super.key,
    this.onPressed,
    this.profissionalEdicao,
  });

  @override
  State<CadastroProfissionalAgendaScreen> createState() =>
      _CadastroProfissionalAgendaScreenState();
}

class _CadastroProfissionalAgendaScreenState
    extends State<CadastroProfissionalAgendaScreen> {
  List<ProfissionalHorario> profissionalHorarios = [];
  List<ProfissionalHorario> profissionalHorariosSalvar = [];
  List<ProfissionalHorario> profissionalHorariosDeletar = [];

  final profissionalHorarioService = ProfissionalHorarioService();
  final _formKey = GlobalKey<FormState>();

  final _horaInicioExpedienteController = TextEditingController();
  final _horaFinalExpedienteController = TextEditingController();
  final _horaInicioIntervaloController = TextEditingController();
  final _horaFinalIntervaloController = TextEditingController();
  int diaSelecionado = 2;

  bool _isLoading = false;

  ThemeData? _theme;
  late ColorScheme _colorScheme;
  late TextTheme _textTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _colorScheme = _theme!.colorScheme;
    _textTheme = _theme!.textTheme;
  }

  @override
  void initState() {
    super.initState();
    buscarListaProfissionalHorarios();
    _horaInicioExpedienteController.text = '08:00';
    _horaFinalExpedienteController.text = '18:00';
    _horaInicioIntervaloController.text = '12:00';
    _horaFinalIntervaloController.text = '13:00';
  }

  void buscarListaProfissionalHorarios() async {
    final lista = await profissionalHorarioService
        .buscarListaProfissionalHorarios(widget.profissionalEdicao!.id!);

    if (!mounted) return;

    setState(() {
      profissionalHorarios = lista;
    });
  }

  @override
  void dispose() {
    _horaInicioExpedienteController.dispose();
    _horaFinalExpedienteController.dispose();
    _horaInicioIntervaloController.dispose();
    _horaFinalIntervaloController.dispose();
    super.dispose();
  }

  void _salvarProfissionalHorario() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    try {
      setState(() => _isLoading = true);
      if (profissionalHorariosDeletar.isNotEmpty) {
        await profissionalHorarioService.deletarProfissionalHorario(
          profissionalHorariosDeletar,
        );
        profissionalHorariosDeletar.clear();
      }

      await profissionalHorarioService.salvarProfissionalHorario(
        profissionalHorariosSalvar,
      );

      if (!mounted) return;
      profissionalHorariosSalvar.clear();
      UtilMensagem.showSucesso(context, "Agenda atualizada!");

      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      UtilMensagem.showErro(context, "Falha ao atualizar agenda: $e");
    }
  }

  List<ProfissionalHorario> gerarHorarios({
    required TimeOfDay inicioExpediente,
    required TimeOfDay fimExpediente,
    required TimeOfDay? inicioIntervalo,
    required TimeOfDay? fimIntervalo,
    int intervaloMinutos = 40,
  }) {
    List<ProfissionalHorario> horarios = [];

    TimeOfDay atual = inicioExpediente;
    TimeOfDay ultimoHorarioExpediente = _addMinutes(
      fimExpediente,
      -intervaloMinutos + 1,
    );
    TimeOfDay ultimoHorarioAntesIntervalo = _addMinutes(
      inicioIntervalo!,
      -intervaloMinutos + 1,
    );

    while (!_isAfter(atual, ultimoHorarioExpediente)) {
      bool dentroIntervalo =
          _isAfter(atual, ultimoHorarioAntesIntervalo) &&
          !_isAfter(atual, fimIntervalo!);

      if (dentroIntervalo) {
        atual = fimIntervalo;
      } else {
        horarios.add(
          ProfissionalHorario(
            diaSemana: diaSelecionado,
            idProfissional: widget.profissionalEdicao!.id!,
            hora: _formatTime(atual),
          ),
        );
        atual = _addMinutes(atual, intervaloMinutos);
      }
    }

    return horarios;
  }

  bool _isAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute >= b.minute);
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    int total = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: total ~/ 60, minute: total % 60);
  }

  String _formatTime(TimeOfDay tod) {
    return "${tod.hour.toString().padLeft(2, '0')}:${tod.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    final listaProfissionalHorariosDiaSelecionado = profissionalHorarios
        .where((horario) => horario.diaSemana == diaSelecionado)
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarPadrao(
        icon: Icons.calendar_month,
        title: 'Agenda do ${widget.profissionalEdicao?.nome}',
        subtitle:
            'Gerencie toda a agenda do profissional cadastrado na plataforma.',
        tituloBotao: '',
        onPressed: () {},
      ),
      bottomNavigationBar: SafeArea(
        child: ButtonBarPadrao(
          onDescartar: () {
            context.go('/profissionais');
          },
          onSalvar: _salvarProfissionalHorario,
          isSaving: _isLoading,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 32),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          flex: 20,
                          child: buildTimeField(
                            controller: _horaInicioExpedienteController,
                            label: 'Horário do início do expediente',
                            icon: Icons.access_time,
                            colorScheme: _colorScheme,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 20,
                          child: buildTimeField(
                            controller: _horaFinalExpedienteController,
                            label: 'Horário do final do expediente',
                            icon: Icons.access_time,
                            colorScheme: _colorScheme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 20,
                          child: buildTimeField(
                            controller: _horaInicioIntervaloController,
                            label: 'Horário do inicio do intervalo',
                            icon: Icons.access_time,
                            colorScheme: _colorScheme,
                            obrigatorio: false,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 20,
                          child: buildTimeField(
                            controller: _horaFinalIntervaloController,
                            label: 'Horário do final do intervalo',
                            icon: Icons.access_time,
                            colorScheme: _colorScheme,
                            obrigatorio: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            if (listaProfissionalHorariosDiaSelecionado
                                .isNotEmpty) {
                              UtilMensagem.showErro(
                                context,
                                'Já existem horários gerados para o dia selecionado. Remova-os antes de gerar novos horários.',
                              );
                              return;
                            }
                            setState(() {
                              final horariosGerados = gerarHorarios(
                                inicioExpediente: UtilTexto.stringToTimeOfDay(
                                  _horaInicioExpedienteController.text,
                                )!,
                                fimExpediente: UtilTexto.stringToTimeOfDay(
                                  _horaFinalExpedienteController.text,
                                )!,
                                inicioIntervalo: UtilTexto.stringToTimeOfDay(
                                  _horaInicioIntervaloController.text,
                                )!,
                                fimIntervalo: UtilTexto.stringToTimeOfDay(
                                  _horaFinalIntervaloController.text,
                                )!,
                              );
                              profissionalHorariosSalvar.addAll(
                                horariosGerados,
                              );
                              profissionalHorarios.addAll(horariosGerados);
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 22,
                            ),
                            foregroundColor: _colorScheme.onSurface.withValues(
                              alpha: 0.8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: _textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Gerar Horários'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DiasSemanaSelector(
                      onDiaSelecionado: (dia) {
                        setState(() {
                          diaSelecionado = dia;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    if (listaProfissionalHorariosDiaSelecionado.isEmpty)
                      const SizedBox(height: 48),
                    if (listaProfissionalHorariosDiaSelecionado.isEmpty)
                      Center(
                        child: Text(
                          'Nenhum horário cadastrado para esse dia da semana.',
                          style: TextStyle(color: _colorScheme.onSurface),
                        ),
                      ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaProfissionalHorariosDiaSelecionado.length,
                      itemBuilder: (context, index) {
                        final item =
                            listaProfissionalHorariosDiaSelecionado[index];

                        return Card(
                          color: themeNotifier.isDarkMode
                          ? _colorScheme.outlineVariant.withValues(alpha: 0.08)
                          : _colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Text(item.hora, style: TextStyle(fontSize: 20)),
                                Spacer(),
                                PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: _colorScheme.onSurface,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'remover') {
                                      setState(() {
                                        profissionalHorariosDeletar.add(item);
                                        profissionalHorarios.removeWhere(
                                          (test) =>
                                              test.diaSemana ==
                                                  item.diaSemana &&
                                              test.hora == item.hora &&
                                              test.idProfissional ==
                                                  item.idProfissional,
                                        );
                                        profissionalHorariosSalvar.removeWhere(
                                          (test) =>
                                              test.diaSemana ==
                                                  item.diaSemana &&
                                              test.hora == item.hora &&
                                              test.idProfissional ==
                                                  item.idProfissional,
                                        );
                                        listaProfissionalHorariosDiaSelecionado
                                            .removeWhere(
                                              (test) =>
                                                  test.diaSemana ==
                                                      item.diaSemana &&
                                                  test.hora == item.hora &&
                                                  test.idProfissional ==
                                                      item.idProfissional,
                                            );
                                      });
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'remover',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            color: _colorScheme.primary,
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
      ),
    );
  }

  Widget buildTimeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    bool obrigatorio = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        TextInputFormatter.withFunction((oldValue, newValue) {
          String text = newValue.text;
          if (text.length >= 3) {
            text = '${text.substring(0, 2)}:${text.substring(2)}';
          }
          return TextEditingValue(
            text: text,
            selection: TextSelection.collapsed(offset: text.length),
          );
        }),
      ],
      validator: (obrigatorio)
          ? (v) {
              if (v == null || v.isEmpty) return 'Preencha o campo "$label"';
              final regex = RegExp(r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$');
              if (!regex.hasMatch(v)) return 'Horário inválido';
              return null;
            }
          : null,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(
          color: colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        filled: true,
        fillColor: colorScheme.onSurface.withValues(alpha: 0.03),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}

class DiasSemanaSelector extends StatefulWidget {
  final Function(int diaSelecionado)? onDiaSelecionado;

  const DiasSemanaSelector({super.key, this.onDiaSelecionado});

  @override
  _DiasSemanaSelectorState createState() => _DiasSemanaSelectorState();
}

class _DiasSemanaSelectorState extends State<DiasSemanaSelector> {
  final List<String> dias = [
    'Domingo',
    'Segunda',
    'Terça',
    'Quarta',
    'Quinta',
    'Sexta',
    'Sábado',
  ];

  int diaSelecionado = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dias.asMap().entries.map((entry) {
          int index = entry.key;
          String dia = entry.value;
          bool selecionado = diaSelecionado == index + 1;

          return GestureDetector(
            onTap: () {
              setState(() => diaSelecionado = index + 1);
              widget.onDiaSelecionado?.call(diaSelecionado);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selecionado ? color.primary : color.surface,
                borderRadius: BorderRadius.circular(10),
                border: selecionado
                    ? null
                    : Border.all(color: color.outlineVariant),
                boxShadow: selecionado
                    ? [
                        BoxShadow(
                          color: color.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                dia,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: selecionado ? color.onPrimary : color.onSurface,
                  fontWeight: selecionado ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
