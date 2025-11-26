import 'package:flutter/material.dart';

class ButtonBarPadrao extends StatefulWidget {
  final VoidCallback onDescartar;
  final VoidCallback onSalvar;
  final bool isSaving;

  const ButtonBarPadrao({
    super.key,
    required this.onDescartar,
    required this.onSalvar,
    this.isSaving = false,
  });

  @override
  State<ButtonBarPadrao> createState() => _ButtonBarPadraoState();
}

class _ButtonBarPadraoState extends State<ButtonBarPadrao> {
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
    if (!mounted) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 32, right: 32, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // --- Botão DESCARTAR ---
          TextButton(
            onPressed: widget.isSaving ? null : widget.onDescartar,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              foregroundColor: _colorScheme.onSurface.withValues(alpha: 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: _textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Descartar'),
          ),

          const SizedBox(width: 24),

          ElevatedButton(
            onPressed: widget.isSaving ? null : widget.onSalvar,
            style: ElevatedButton.styleFrom(
              backgroundColor: _colorScheme.primary,
              foregroundColor: _colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            child: widget.isSaving
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: _colorScheme.onPrimary,
                    ),
                  )
                : const Text('Salvar', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
