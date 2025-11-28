import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/services/servico_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/button_bar_padrao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CadastroServicoScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  final Servico? servicoEdicao;

  const CadastroServicoScreen({super.key, this.onPressed, this.servicoEdicao});

  @override
  State<CadastroServicoScreen> createState() => _CadastroServicoScreenState();
}

class _CadastroServicoScreenState extends State<CadastroServicoScreen> {
  final ServicoService servicoService = ServicoService();
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _tempoController = TextEditingController();
  final _precoController = TextEditingController();

  bool _ativo = true;
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
    if (widget.servicoEdicao != null) {
      _descricaoController.text = widget.servicoEdicao!.descricao;
      _tempoController.text = widget.servicoEdicao!.tempo;
      _precoController.text = widget.servicoEdicao!.preco.toString();
      _ativo = widget.servicoEdicao!.ativo == 1;
    }
  }

  void _salvarServicos() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      Servico servicoSalvar = Servico(
        id: widget.servicoEdicao?.id ?? 0,
        idEmpresa: ListaEmpresaSingleton.instance.empresa!.id,
        descricao: _descricaoController.text,
        tempo: _tempoController.text,
        preco: _precoController.text.isNotEmpty
            ? UtilTexto.textoToDouble(_precoController.text)
            : 0,
        ativo: _ativo ? 1 : 0,
      );

      if ((widget.servicoEdicao?.id ?? 0) == 0) {
        await servicoService.salvarServico(servicoSalvar);

        if (!mounted) return;
        UtilMensagem.showSucesso(context, "Serviço cadastrado com sucesso!");

        setState(() => _isLoading = false);

        if (mounted) context.go('/servicos');
      } else {
        await servicoService.atualizarServico(servicoSalvar);

        if (!mounted) return;
        UtilMensagem.showSucesso(context, "Serviço atualizado com sucesso!");

        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      UtilMensagem.showErro(context, "Falha ao atualizar serviço: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBarPadrao(
        icon: Icons.content_cut,
        title: 'Cadastro de Serviço',
        subtitle: 'Gerencie todas os serviços cadastrados na plataforma.',
        tituloBotao: '',
        onPressed: () {},
      ),
      bottomNavigationBar: SafeArea(
        child: ButtonBarPadrao(
          onDescartar: () {
            context.go('/servicos');
          },
          onSalvar: _salvarServicos,
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
                            (_ativo) ? 'Serviço Ativo' : 'Serviço Desativado',
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
                    _buildTextField(
                      controller: _descricaoController,
                      label: "Descrição do Serviço",
                      icon: Icons.content_cut,
                      colorScheme: _colorScheme,
                      validador: (v) => v == null || v.isEmpty || v.length < 3
                          ? 'Preencha o campo "Descrição do Serviço"'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _tempoController,
                      label: "Tempo Estimado em minutos(ex: 40)",
                      icon: Icons.access_time,
                      keyboardType: TextInputType.number,
                      colorScheme: _colorScheme,
                      validador: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Preencha o Tempo Estimado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _precoController,
                      label: "Preço",
                      icon: Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                      colorScheme: _colorScheme,
                      validador: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Preencha o Preço';
                        }
                        return null;
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
    FormFieldValidator<String?>? validador,
    List<TextInputFormatter>? mascara,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: colorScheme.onSurface),
      inputFormatters: mascara,
      validator:
          validador ??
          (v) => v == null || v.isEmpty ? 'Preencha o campo "$label"' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _descricaoController.dispose();
    _tempoController.dispose();
    _precoController.dispose();
    super.dispose();
  }
}
