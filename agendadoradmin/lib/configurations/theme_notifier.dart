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
        primary: Colors.orange,
        onPrimary: Colors.white,
        secondary: Colors.grey[700]!,
        onSecondary: Colors.white,
        surfaceContainer: Color(0xFF181818),
        onSurfaceVariant: Color(0xFF232323),
        surface: Color(0xFF232323),
        onSurface: Colors.white70,
        error: Colors.redAccent,
        onError: Colors.white,
      ),
    );
  }

  ThemeData themeClaro() {
    return ThemeData.light().copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        surface: Color(0xFFf6f6f6),
        onSurface: Colors.black87,
        primary: Colors.black,
        onPrimary: Color(0xFFf6f6f6),
        onSurfaceVariant: Color(0xFFEEEEEE),
        surfaceContainer: Colors.white,
        error: Colors.redAccent,
        onError: Colors.white,
        secondary: Colors.grey[700]!,
        onSecondary: Colors.black,
      ),
    );
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    Util.salvaDadosLocal('_isDarkMode', _isDarkMode ? 'true': 'false');
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
