import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:agendadoradmin/models/usuario.dart';
import 'package:agendadoradmin/services/login_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginService loginService = LoginService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = "jean.fialkoski@gmail.com";
    _senhaController.text = "123456789";
  }

  void _realizarLogin() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    loginService
        .login(
          Usuario(
            id: 0,
            nome: "",
            email: _emailController.text.toLowerCase(),
            senha: _senhaController.text,
            uidgoogle: "",
          ),
        )
        .then((msg) {
          setState(() => _isLoading = false);
          if (!mounted) return;
          context.go('/dashboard');
        })
        .catchError((e) {
          setState(() => _isLoading = false);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$e'), duration: const Duration(seconds: 8)),
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
    final colors = theme.colorScheme;
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
                  "Entrar na sua conta",
                  style: GoogleFonts.montserrat(
                    color: colors.onSurface,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Organize sua barbearia com praticidade e estilo!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: colors.onSurface.withValues(alpha: 0.7),
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 40),

                /// FORMULÁRIO
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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

                /// BOTÃO ENTRAR
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _realizarLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: colors.onPrimary)
                        : const Text(
                            "Entrar",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                /// DIVISOR
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.outlineVariant)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "ou entre com",
                        style: GoogleFonts.openSans(
                          color: colors.onSurface.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.outlineVariant)),
                  ],
                ),

                const SizedBox(height: 20),

                /// BOTÃO GOOGLE
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: _loginComGoogle,
                    icon: FaIcon(
                      FontAwesomeIcons.google,
                      color: colors.primary,
                    ),
                    label: Text(
                      "Entrar com Google",
                      style: TextStyle(color: colors.onSurface, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                TextButton(
                  onPressed: () => context.go('/cadastro'),
                  child: Text(
                    "Ainda não tem uma conta? Cadastre-se",
                    style: TextStyle(color: colors.primary),
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
