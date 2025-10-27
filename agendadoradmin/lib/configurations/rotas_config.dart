import 'package:agendadoradmin/models/Profissional.dart';
import 'package:agendadoradmin/screens/cadastros_profissional_screen.dart';
import 'package:agendadoradmin/screens/nao_encontrado_screen.dart';
import 'package:agendadoradmin/screens/principal_screen.dart';
import 'package:agendadoradmin/screens/servicos_screen.dart';
import 'package:agendadoradmin/screens/cadastro_empresa_screen.dart';
import 'package:agendadoradmin/screens/cadastro_usuario_screen.dart';
import 'package:agendadoradmin/screens/dashboard_screen.dart';
import 'package:agendadoradmin/screens/landing_page_screen.dart';
import 'package:agendadoradmin/screens/lista_empresas_screen.dart';
import 'package:agendadoradmin/screens/lista_profissionais_screen.dart';
import 'package:agendadoradmin/screens/login_screen.dart';
import 'package:agendadoradmin/singleton/empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:go_router/go_router.dart';


class RotasConfig {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final tokenValido = UsuarioSingleton.instance.tokenValido();
      final rotaSemToken = state.uri.toString() == '/login' ||
          state.uri.toString() == '/cadastro' ||
          state.uri.toString() == '/';
      if (!tokenValido && !rotaSemToken) return '/login';
      return null; 
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPageScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroUsuarioScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => PrincipalScreen(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) {
              return DashboardScreen();
            },
          ),
          GoRoute(
            path: '/profissionais',
            builder: (context, state) => const ListaProfissionaisScreen(),
          ),
          GoRoute(
            path: '/empresas',
            builder: (context, state) => const ListaEmpresasScreen(),
          ),
          GoRoute(
            path: '/empresas/cadastro',
            builder: (context, state) => const CadastroEmpresaScreen(),
          ),
          GoRoute(
            path: '/profissionais/cadastro',
            builder: (context, state) {
              final profissional = state.extra as Profissional?;
              return CadastroProfissionalScreen(profissional: profissional);
            },
          ),
          GoRoute(
            path: '/servicos',
            builder: (context, state) {
              int idEmpresa = EmpresaSingleton.instance.empresa!.id;
              return ServicosScreen(empresaId: idEmpresa);
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const NaoEncontradoScreen(mensagem: "CNPJ/CPF não informado"),
  );

  static GoRouter getRouter() => _router;
}
