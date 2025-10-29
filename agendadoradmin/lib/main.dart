import 'package:agendadoradmin/providers/empresa_provider.dart';
import 'package:agendadoradmin/services/api_service.dart';
import 'package:agendadoradmin/singleton/usuario_singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configurations/rotas_config.dart';
import 'configurations/theme_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UsuarioSingleton.instance.carregarUsuario();

  ApiService.onRedirecionamento = () {
    Future.microtask(() => RotasConfig.getRouter().go('/login'));
  };
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => EmpresaProvider()..adicionarEmpresa()),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.themeClaro(),
      darkTheme: themeNotifier.themeDark(),
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: RotasConfig.getRouter(),
    );
  }
}
