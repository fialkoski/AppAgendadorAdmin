import 'package:agendadoradmin/models/empresa.dart';
import 'package:agendadoradmin/models/profissional.dart';
import 'package:agendadoradmin/models/servico.dart';
import 'package:agendadoradmin/screens/agenda_screen.dart';
import 'package:agendadoradmin/screens/cadastros_profissional_agenda_screen.dart';
import 'package:agendadoradmin/screens/cadastros_profissional_screen.dart';
import 'package:agendadoradmin/screens/cadastros_servico_screen.dart';
import 'package:agendadoradmin/screens/lista_servicos_screen.dart';
import 'package:agendadoradmin/screens/nao_encontrado_screen.dart';
import 'package:agendadoradmin/screens/principal_screen.dart';
import 'package:agendadoradmin/screens/cadastro_empresa_screen.dart';
import 'package:agendadoradmin/screens/cadastro_usuario_screen.dart';
import 'package:agendadoradmin/screens/dashboard_screen.dart';
import 'package:agendadoradmin/screens/landing_page_screen.dart';
import 'package:agendadoradmin/screens/lista_empresas_screen.dart';
import 'package:agendadoradmin/screens/lista_profissionais_screen.dart';
import 'package:agendadoradmin/screens/login_screen.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:go_router/go_router.dart';

class RotasConfig {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final tokenValido = UsuarioSingleton.instance.tokenValido();
      final rotaSemToken =
          state.uri.toString() == '/login' ||
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
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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
            path: '/empresas',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ListaEmpresasScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                pageBuilder: (context, state) {
                  final empresa = state.extra as Empresa?;
                  return NoTransitionPage(
                    child: CadastroEmpresaScreen(empresaEdicao: empresa),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profissionais',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ListaProfissionaisScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                pageBuilder: (context, state) {
                  final profissional = state.extra as Profissional?;
                  return NoTransitionPage(
                    child: CadastroProfissionalScreen(
                      profissionalEdicao: profissional,
                    ),
                  );
                },
              ),
               GoRoute(
                path: 'cadastroagenda',
                pageBuilder: (context, state) {
                  final profissional = state.extra as Profissional?;
                  if (profissional == null) {
                    context.go('/profissionais');
                  }
                  return NoTransitionPage(
                    child: CadastroProfissionalAgendaScreen(
                      profissionalEdicao: profissional,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/servicos',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ListaServicosScreen()),
            routes: [
              GoRoute(
                path: 'cadastro',
                pageBuilder: (context, state) {
                  final servico = state.extra as Servico?;
                  return NoTransitionPage(
                    child: CadastroServicoScreen(servicoEdicao: servico),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/agendas',
            builder: (context, state) {
              return AgendaScreen();
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        const NaoEncontradoScreen(mensagem: "Pagina não encontrada!"),
  );

  static GoRouter getRouter() => _router;
}
