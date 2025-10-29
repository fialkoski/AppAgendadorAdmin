import 'package:flutter/material.dart';

class AppBarPadrao extends StatefulWidget implements PreferredSizeWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String tituloBotao;
  final VoidCallback? onPressed;

  const AppBarPadrao({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tituloBotao,
    required this.onPressed,
  });

  @override
  State<AppBarPadrao> createState() => _AppBarPadraoState();

  @override
  Size get preferredSize => const Size.fromHeight(130);
}

class _AppBarPadraoState extends State<AppBarPadrao> {
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
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink(); // Proteção adicional

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        children: [
          if (widget.icon != null)
            Icon(
              widget.icon,
              size: 80,
              color: _colorScheme.primary,
            ),
          if (widget.icon != null) const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: _textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _colorScheme!.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: _textTheme.bodyMedium?.copyWith(
                  color: _colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Spacer(),
          if (widget.tituloBotao.isNotEmpty)
            ElevatedButton.icon(
              onPressed: widget.onPressed,
              icon: Icon(Icons.add, color: _colorScheme.onPrimary),
              label: Text(
                widget.tituloBotao,
                style: TextStyle(color: _colorScheme.onPrimary),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorScheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
              ),
            ),
        ],
      ),
    );
  }
}