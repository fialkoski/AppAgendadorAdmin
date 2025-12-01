import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/lista_empresa_singleton.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configurations/rotas_config.dart';
import 'configurations/theme_notifier.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UsuarioSingleton.instance.carregarUsuario();
  await ListaEmpresaSingleton.instance.buscarListaEmpresa();

  ApiService.onRedirecionamento = () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RotasConfig.getRouter().go('/login');
    });
  };

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EmpresaProvider())],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Chamada da empresa após o primeiro frame para evitar erro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmpresaProvider>().adicionarEmpresa();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp.router(
          locale: const Locale('pt', 'BR'),

          supportedLocales: const [Locale('pt', 'BR')],

          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          debugShowCheckedModeBanner: false,
          theme: themeNotifier.themeClaro(),
          darkTheme: themeNotifier.themeDark(),
          themeMode: themeNotifier.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: RotasConfig.getRouter(),
        );
      },
    );
  }
}
