import 'package:flutter/material.dart';

class NaoEncontradoScreen extends StatelessWidget {
  final String mensagem;
  const NaoEncontradoScreen({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 80,
            ),
            SizedBox(height: 24),
            Text(
              'Barbearia não encontrada!',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            SizedBox(height: 8),
            Text(
              mensagem.replaceAll('Falha ao buscar dados:', '').replaceAll('Data:', ''),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
