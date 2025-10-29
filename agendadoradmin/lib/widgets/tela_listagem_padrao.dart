import 'package:flutter/material.dart';

class TelaListagemPadrao extends StatefulWidget {
  final String titulo;
  final Widget dataTable;

  const TelaListagemPadrao({
    super.key,
    required this.titulo,
    required this.dataTable,
  });

  @override
  State<TelaListagemPadrao> createState() => _TelaListagemPadraoState();
}

class _TelaListagemPadraoState extends State<TelaListagemPadrao> {
  ThemeData? _theme;
  late ColorScheme _colorScheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _theme = Theme.of(context);
    _colorScheme = _theme!.colorScheme;
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox.shrink();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: widget.dataTable)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
