import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/empresa_service.dart';
import 'package:agendadoradmin/widgets/app_bar_padrao.dart';
import 'package:agendadoradmin/widgets/button_bar_padrao.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CadastroEmpresaScreen extends StatefulWidget {
  final VoidCallback? onPressed;
  const CadastroEmpresaScreen({super.key, this.onPressed});

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

  void _salvarEmpresa() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final empresaJson = {
      "nome": _nomeController.text,
      "cpfCnpj": _cpfCnpjController.text,
      "foto": null,
      "ativo": _ativo ? 1 : 0,
      "whatsApp": _whatsAppController.text,
      "endereco": {
        "rua": _ruaController.text,
        "numero": _numeroController.text,
        "bairro": _bairroController.text,
        "cidade": _cidadeController.text,
        "cep": _cepController.text,
      }
    };
    Empresa empresa = Empresa.fromJson(empresaJson);
    empresaService.salvarEmpresa(empresa);

    final provider = context.read<EmpresaProvider>();
    await provider.adicionarEmpresa();

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Empresa cadastrada com sucesso!')),
    );
    context.go('/profissionais');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
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
                  
                  constraints:
                      const BoxConstraints(maxWidth: 1200), // Limite de largura
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
                                'Empresa Ativa',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              Switch(
                                value: _ativo,
                                onChanged: (v) => setState(() => _ativo = v),
                                activeColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nomeController,
                          label: "Nome da Empresa",
                          icon: Icons.business,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _cpfCnpjController,
                          label: "CPF/CNPJ",
                          icon: Icons.badge_outlined,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _whatsAppController,
                          label: "WhatsApp",
                          icon: Icons.phone_android,
                          keyboardType: TextInputType.phone,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Endereço",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(color: colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTextField(
                          controller: _ruaController,
                          label: "Rua",
                          icon: Icons.location_on_outlined,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildTextField(
                                controller: _numeroController,
                                label: "Número",
                                icon: Icons.confirmation_number_outlined,
                                keyboardType: TextInputType.number,
                                colorScheme: colorScheme,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 3,
                              child: _buildTextField(
                                controller: _bairroController,
                                label: "Bairro",
                                icon: Icons.home_outlined,
                                colorScheme: colorScheme,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _cidadeController,
                          label: "Cidade",
                          icon: Icons.location_city_outlined,
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _cepController,
                          label: "CEP",
                          icon: Icons.markunread_mailbox_outlined,
                          keyboardType: TextInputType.number,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ),
                ),
              ))),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: colorScheme.onSurface),
      validator: (v) =>
          v == null || v.isEmpty ? 'Preencha o campo "$label"' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: colorScheme.primary),
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest ?? Colors.black12,
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
}
