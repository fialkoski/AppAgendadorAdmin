import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:agendadoradmin/tools/util_mensagem.dart';
import 'package:agendadoradmin/tools/util_texto.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/button_bar_padrao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:cpf_cnpj_validator/cnpj_validator.dart';

class CadastroEmpresaScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  final Empresa? empresaEdicao;

  const CadastroEmpresaScreen({super.key, this.onPressed, this.empresaEdicao});

  @override
  State<CadastroEmpresaScreen> createState() => _CadastroEmpresaScreenState();
}

class _CadastroEmpresaScreenState extends State<CadastroEmpresaScreen> {
  final EmpresaService empresaService = EmpresaService();
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cepController = TextEditingController();

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
    if (widget.empresaEdicao != null) {
      _nomeController.text = widget.empresaEdicao!.nome;
      _cpfCnpjController.text = widget.empresaEdicao!.cpfCnpj;
      _whatsAppController.text = widget.empresaEdicao!.whatsApp;
      _ruaController.text = widget.empresaEdicao!.endereco.rua;
      _numeroController.text = widget.empresaEdicao!.endereco.numero;
      _bairroController.text = widget.empresaEdicao!.endereco.bairro;
      _cidadeController.text = widget.empresaEdicao!.endereco.cidade;
      _cepController.text = widget.empresaEdicao!.endereco.cep;
      _ativo = widget.empresaEdicao!.ativo == 1;
    }
  }

  void _salvarEmpresa() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    try {
      setState(() => _isLoading = true);

      final empresaJson = {
        "id": widget.empresaEdicao?.id ?? 0,
        "nome": _nomeController.text,
        "cpfCnpj": _cpfCnpjController.text,
        "foto": null,
        "ativo": _ativo ? 1 : 0,
        "whatsApp": UtilTexto.apenasNumeros(_whatsAppController.text),
        "idUsuario": UsuarioSingleton.instance.usuario!.id,
        "endereco": {
          "rua": _ruaController.text,
          "numero": _numeroController.text,
          "bairro": _bairroController.text,
          "cidade": _cidadeController.text,
          "cep": _cepController.text,
        },
      };

      Empresa empresa = Empresa.fromJson(empresaJson);

      if ((widget.empresaEdicao?.id ?? 0) == 0) {
        await empresaService.salvarEmpresa(empresa);

        if (!mounted) return;
        UtilMensagem.showSucesso(context, "Empresa cadastrada com sucesso!");

        final provider = context.read<EmpresaProvider>();
        provider.adicionarEmpresa();

        setState(() => _isLoading = false);

        if (mounted) context.go('/profissionais');
      } else {
        await empresaService.atualizarEmpresa(empresa);

        if (!mounted) return;
        UtilMensagem.showSucesso(context, "Empresa atualizada com sucesso!");

        setState(() => _isLoading = false);
      }

    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      UtilMensagem.showErro(context, "Falha ao atualizar empresa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: _colorScheme.surfaceContainer,
      appBar: AppBarPadrao(
        icon: Icons.apartment,
        title: 'Cadastro de empresa',
        subtitle: 'Gerencie todas as empresas cadastradas na plataforma.',
        tituloBotao: '',
        onPressed: () {},
      ),
      bottomNavigationBar: SafeArea(
        child: ButtonBarPadrao(
          onDescartar: () {
            context.go('/empresas');
          },
          onSalvar: _salvarEmpresa,
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
                            (_ativo)?'Empresa Ativa': 'Empresa Desativada' ,
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
                      controller: _nomeController,
                      label: "Nome da Empresa",
                      icon: Icons.business,
                      colorScheme: _colorScheme,
                      validador: (v) => v == null || v.isEmpty || v.length < 3
                          ? 'Preencha o campo "Nome da Empresa"'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cpfCnpjController,
                      label: "CPF/CNPJ",
                      icon: Icons.badge_outlined,
                      colorScheme: _colorScheme,
                      validador: (v) => validarCpfOuCnpj(v),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _whatsAppController,
                      label: "WhatsApp",
                      icon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                      colorScheme: _colorScheme,
                      mascara: [UtilTexto.mascaraTelefoneFormatter()],
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Endereço"),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _cepController,
                      label: "CEP",
                      icon: Icons.markunread_mailbox_outlined,
                      keyboardType: TextInputType.number,
                      colorScheme: _colorScheme,
                      mascara: [UtilTexto.mascaraCepFormatter()],
                      validador: (v) {
                        if (v == null || v.isEmpty) return 'Preencha o CEP';
                        if (v.length < 9) return 'CEP inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 70,
                          child: _buildTextField(
                            controller: _ruaController,
                            label: "Rua",
                            icon: Icons.location_on_outlined,
                            colorScheme: _colorScheme,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 30,
                          child: _buildTextField(
                            controller: _numeroController,
                            label: "Número",
                            icon: Icons.confirmation_number_outlined,
                            keyboardType: TextInputType.number,
                            colorScheme: _colorScheme,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: _buildTextField(
                            controller: _bairroController,
                            label: "Bairro",
                            icon: Icons.home_outlined,
                            colorScheme: _colorScheme,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 50,
                          child: _buildTextField(
                            controller: _cidadeController,
                            label: "Cidade",
                            icon: Icons.location_city_outlined,
                            colorScheme: _colorScheme,
                          ),
                        ),
                      ],
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
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
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
    _cpfCnpjController.dispose();
    _whatsAppController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _cepController.dispose();
    super.dispose();
  }
}
