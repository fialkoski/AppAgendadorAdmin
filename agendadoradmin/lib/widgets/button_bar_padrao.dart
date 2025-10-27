import 'package:flutter/material.dart';

class ButtonBarPadrao extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 32, right: 32, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // --- Botão DESCARTAR ---
          TextButton(
            onPressed: isSaving ? null : onDescartar,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              foregroundColor: colorScheme.onSurface.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Descartar'),
          ),

          const SizedBox(width: 24),

          ElevatedButton(
            onPressed: isSaving ? null : onSalvar,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            child: isSaving
                ? SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Text(
                    'Salvar',
                    style: TextStyle(fontSize: 16,),
                  ),
          ),
        ],
      ),
    );
  }
}
