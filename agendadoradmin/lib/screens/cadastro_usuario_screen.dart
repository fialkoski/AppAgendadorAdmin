import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/usuario.dart';
import 'package:agendadoradmin/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CadastroUsuarioScreen extends StatefulWidget {
  const CadastroUsuarioScreen({super.key});

  @override
  State<CadastroUsuarioScreen> createState() => _CadastroUsuarioScreenState();
}

class _CadastroUsuarioScreenState extends State<CadastroUsuarioScreen> {
  UsuarioService usuarioService = UsuarioService();
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  void _criarConta() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    usuarioService
        .salvarUsuario(
          Usuario(
            id: 0,
            nome: _nomeController.text,
            email: _emailController.text.toLowerCase(),
            senha: _senhaController.text,
            uidgoogle: "",
          ),
        )
        .then((msg) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          context.go('/login');
        })
        .catchError((e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao criar conta: $e'),
              duration: const Duration(seconds: 5),
            ),
          );
        });
  }

  void _loginComGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Essa funcionalidade ainda não está pronta… mas logo, logo você vai poder usar!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  themeNotifier.isDarkMode
                      ? "assets/img/logo128.png"
                      : "assets/img/logoClaro128.png",
                  height: 150,
                ),
                const SizedBox(height: 20),

                Text(
                  "Crie sua conta",
                  style: GoogleFonts.montserrat(
                    textStyle: theme.textTheme.headlineMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Organize sua barbearia com praticidade e estilo!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nomeController,
                        label: "Nome completo",
                        icon: Icons.person_outline,
                        validator: (v) =>
                            v!.isEmpty ? 'Informe seu nome' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _emailController,
                        label: "E-mail",
                        icon: Icons.email_outlined,
                        validator: (v) =>
                            v!.contains('@') ? null : 'E-mail inválido',
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _senhaController,
                        label: "Senha",
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) =>
                            v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _criarConta,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: cs.onPrimary)
                        : Text(
                            "Criar conta",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: cs.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "ou entre com",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: cs.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: _loginComGoogle,
                    icon: FaIcon(FontAwesomeIcons.google, color: cs.primary),
                    label: Text(
                      "Entrar com Google",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onSurface,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    "Já tem conta? Faça login",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: colors.primary),
        labelText: label,
        labelStyle: TextStyle(color: colors.onSurface.withValues(alpha: 0.7)),
        filled: true,
        fillColor:
            theme.inputDecorationTheme.fillColor ??
            colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
      ),
    );
  }
}
