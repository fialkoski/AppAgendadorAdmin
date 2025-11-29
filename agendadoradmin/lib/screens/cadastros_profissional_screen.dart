import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/models/profissional_servico.dart';
import 'package:agendadoradmin/services/profissional_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/button_bar_padrao.dart';
import 'package:agendadoradmin/widgets/textfield_padrao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:provider/provider.dart';

class CadastroProfissionalScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  Profissional? profissionalEdicao;

  CadastroProfissionalScreen({
    super.key,
    this.onPressed,
    this.profissionalEdicao,
  });

  @override
  State<CadastroProfissionalScreen> createState() =>
      _CadastroProfissionalScreenState();
}

class _CadastroProfissionalScreenState
    extends State<CadastroProfissionalScreen> {
  final ProfissionalService profissionalService = ProfissionalService();
  List<ProfissionalServico> listaProfissionalServicos = [];
  List<ProfissionalServico> listaProfissionalServicosSalvar = [];
  List<ProfissionalServico> listaProfissionalServicosDeletar = [];
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  bool _ativo = true;
  bool _isLoading = false;
  bool _carregandoServicos = false;

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

    if (widget.profissionalEdicao != null) {
      _nomeController.text = widget.profissionalEdicao!.nome;
      _emailController.text = widget.profissionalEdicao!.email;
      _ativo = widget.profissionalEdicao!.ativo == 1;
    }
    buscarListaProfissionalServicos();
  }

  void buscarListaProfissionalServicos() async {
    setState(() {
      _carregandoServicos = true;
    });
    try {
      final lista = await profissionalService.buscarListaProfissionalServicos(
        widget.profissionalEdicao?.id ?? 0,
      );

      if (!mounted) return;

      setState(() {
        listaProfissionalServicos = lista;
        _carregandoServicos = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _carregandoServicos = false);
      UtilMensagem.showErro(context, "Falha ao buscar lista de serviços: $e");
    }
  }

  void _salvarProfissional() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      Profissional prof = Profissional(
        id: widget.profissionalEdicao?.id ?? 0,
        idEmpresa: ListaEmpresaSingleton.instance.empresa!.id,
        nome: _nomeController.text,
        email: _emailController.text.toLowerCase(),
        // foto: _fotoUrl ?? widget.profissional?.foto ?? '',
        ativo: _ativo ? 1 : 0,
      );

      if ((widget.profissionalEdicao?.id ?? 0) == 0) {
        var profissionalSalvo = await profissionalService.salvarProfissional(
          prof,
        );

        widget.profissionalEdicao = profissionalSalvo;

        if (listaProfissionalServicosDeletar.isNotEmpty) {
          listaProfissionalServicosDeletar.forEach((item) {
            item.idProfissional = profissionalSalvo.id!;
          });
          await profissionalService.deletarProfissionalServico(
            listaProfissionalServicosDeletar,
          );
          listaProfissionalServicosDeletar.clear();
        }

        if (listaProfissionalServicosSalvar.isNotEmpty) {
          listaProfissionalServicosSalvar.forEach((item) {
            item.idProfissional = profissionalSalvo.id!;
          });

          await profissionalService.salvarProfissionalServico(
            listaProfissionalServicosSalvar,
          );
          listaProfissionalServicosSalvar.clear();
        }

        if (!mounted) return;
        UtilMensagem.showSucesso(
          context,
          "Profissional cadastrado com sucesso!",
        );

        setState(() => _isLoading = false);
      } else {
        var profissionalSalvo = await profissionalService.atualizarProfissional(
          prof,
        );
        widget.profissionalEdicao = profissionalSalvo;

        if (listaProfissionalServicosDeletar.isNotEmpty) {
          listaProfissionalServicosDeletar.forEach((item) {
            item.idProfissional = profissionalSalvo.id!;
          });
          await profissionalService.deletarProfissionalServico(
            listaProfissionalServicosDeletar,
          );
          listaProfissionalServicosDeletar.clear();
        }

        if (listaProfissionalServicosSalvar.isNotEmpty) {
          listaProfissionalServicosSalvar.forEach((item) {
            item.idProfissional = profissionalSalvo.id!;
          });

          await profissionalService.salvarProfissionalServico(
            listaProfissionalServicosSalvar,
          );
          listaProfissionalServicosSalvar.clear();
        }

        if (!mounted) return;
        UtilMensagem.showSucesso(
          context,
          "Profissional atualizado com sucesso!",
        );

        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      UtilMensagem.showErro(context, "Falha ao atualizar profissional: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarPadrao(
        icon: Icons.person,
        title: 'Cadastro de Profissional',
        subtitle: 'Gerencie todas os profissionais cadastrados na plataforma.',
        tituloBotao: 'Editar Agenda',
        onPressed: () {
          if (widget.profissionalEdicao == null) {
            UtilMensagem.showErro(
              context,
              "Finalize o cadastro do profissional para liberar a edição da agenda.",
            );
            return;
          }
          context.go(
            '/profissionais/cadastroagenda',
            extra: widget.profissionalEdicao,
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: ButtonBarPadrao(
          onDescartar: () {
            context.go('/profissionais');
          },
          onSalvar: _salvarProfissional,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (_ativo)
                                ? 'Profissional Ativo'
                                : 'Profissional Desativado',
                            style: _textTheme.bodyMedium?.copyWith(
                              color: _colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Switch(
                            value: _ativo,
                            onChanged: (v) => setState(() => _ativo = v),
                            activeColor: _colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFieldPadrao(
                      controller: _nomeController,
                      label: "Nome do Profissional",
                      icon: Icons.person,
                      colorScheme: _colorScheme,
                      validator: (v) => v == null || v.isEmpty || v.length < 3
                          ? 'Preencha o campo "Nome do Profissional"'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    TextFieldPadrao(
                      controller: _emailController,
                      label: "E-mail",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      colorScheme: _colorScheme,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Preencha o E-mail';
                        if (v.contains('@') == false) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Lista de Serviços"),
                    ),
                    const SizedBox(height: 12),
                    if (listaProfissionalServicos.isEmpty)
                      const SizedBox(height: 48),
                    if (_carregandoServicos)
                      Center(child: CircularProgressIndicator()),
                    if (listaProfissionalServicos.isEmpty &&
                        (!_carregandoServicos))
                      Center(
                        child: Text(
                          'Nenhum serviço cadastrado.',
                          style: TextStyle(color: _colorScheme.onSurface),
                        ),
                      ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listaProfissionalServicos.length,
                      itemBuilder: (context, index) {
                        final item = listaProfissionalServicos[index];

                        return Card(
                          color: themeNotifier.isDarkMode
                          ? _colorScheme.outlineVariant.withValues(alpha: 0.08)
                          : _colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: item.habilitado == 1,
                                  side: BorderSide(
                                    color: _colorScheme.onSurface.withValues(
                                      alpha: 0.8,
                                    ), // borda
                                    width: 2,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      item.habilitado = value! ? 1 : 0;
                                      item.idProfissional =
                                          widget.profissionalEdicao?.id ?? 0;
                                      if (item.habilitado == 1) {
                                        listaProfissionalServicosSalvar.add(
                                          item,
                                        );
                                        listaProfissionalServicosDeletar
                                            .removeWhere(
                                              (test) =>
                                                  test.idServico ==
                                                  item.idServico,
                                            );
                                      } else {
                                        listaProfissionalServicosDeletar.add(
                                          item,
                                        );
                                        listaProfissionalServicosSalvar
                                            .removeWhere(
                                              (test) =>
                                                  test.idServico ==
                                                  item.idServico,
                                            );
                                      }
                                    });
                                  },
                                ),
                                SizedBox(width: 8),
                                Text(item.descricao),
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

  String? validarCpfOuCnpj(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Preencha o campo "CPF ou CNPJ"';
    }

    final valor = v.replaceAll(RegExp(r'[^0-9]'), '');

    if (valor.length <= 11) {
      if (!CPFValidator.isValid(valor)) {
        return 'CPF inválido';
      }
    } else {
      if (!CNPJValidator.isValid(valor)) {
        return 'CNPJ inválido';
      }
    }

    return null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
