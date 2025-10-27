import 'package:flutter/material.dart';

class AppBarPadrao extends StatelessWidget implements PreferredSizeWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final String tituloBotao;
  final VoidCallback? onPressed;

  const AppBarPadrao(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      required this.tituloBotao,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 80,
                color: colorScheme.primary,
              ),
            if (icon != null) const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Spacer(),
            if (tituloBotao.isNotEmpty)
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(Icons.add, color: colorScheme.onPrimary),
                label: Text(
                  tituloBotao,
                  style: TextStyle(color: colorScheme.onPrimary),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
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
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(130);
}
