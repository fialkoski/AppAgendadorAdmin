import 'package:flutter/material.dart';

class TelaListagemPadrao extends StatelessWidget {
  final String titulo;
  final Widget dataTable;

  const TelaListagemPadrao(
      {super.key,
      required this.titulo,
      required this.dataTable});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: dataTable
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
