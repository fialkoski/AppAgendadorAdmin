import 'package:agendadoradmin/tools/util.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  bool _isDarkMode = true;

  ThemeNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _isDarkMode = Util.buscarDadosLocal('_isDarkMode').toString() == 'true';
  }

  bool get isDarkMode => _isDarkMode;

  ThemeData get theme => _isDarkMode ? themeDark() : themeClaro();

  ThemeData themeDark() {
    return ThemeData.dark().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFFD4A056), // Dourado premium
        onPrimary: Colors.black, // Melhor contraste

        secondary: Color(0xFF6D6D6D), // Cinza metálico
        onSecondary: Colors.white,

        surface: Color(0xFF1E1E1E), // Grafite para cards
        onSurface: Color(0xFFE0E0E0), // Texto claro

        surfaceContainer: Color(0xFF121212), // Fundo principal
        onSurfaceVariant: Color(0xFF2A2A2A), // Divisores / detalhes

        error: Color(0xFFCF6679), // Vermelho dark
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: Color(0xFF121212),
      cardColor: Color(0xFF1E1E1E),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Colors.white,
      ),
      dividerColor: Color(0xFF2A2A2A),
    );
  }

  ThemeData themeClaro() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,

        primary: Color(0xFFD4A056), // Dourado premium
        onPrimary: Colors.white, // Contraste no botão

        secondary: Color(0xFF6D6D6D), // Cinza metálico
        onSecondary: Colors.white,

        surface: Color(0xFFFFFFFF), // Containers brancos
        onSurface: Color(0xFF1A1A1A), // Texto escuro

        surfaceContainer: Color(0xFFF5F5F5), // Fundo geral claro
        onSurfaceVariant: Color(0xFFE0E0E0), // Bordas / divisores

        error: Color(0xFFD32F2F),
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A1A1A),
        elevation: 0,
      ),
      dividerColor: Color(0xFFE0E0E0),
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    Util.salvaDadosLocal('_isDarkMode', _isDarkMode ? 'true' : 'false');
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _isDarkMode = brightness == Brightness.dark;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
