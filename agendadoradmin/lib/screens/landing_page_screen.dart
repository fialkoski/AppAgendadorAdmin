import 'package:agendadoradmin/configurations/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<ThemeNotifier>(
              builder: (context, themeNotifier, child) => ListTile(
                leading: Icon(
                  themeNotifier.isDarkMode ? Icons.wb_sunny : Icons.nights_stay,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  'Tema ${themeNotifier.isDarkMode ? 'Claro' : 'Escuro'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                onTap: () {
                  themeNotifier.toggleTheme();
                },
              ),
            ),
            _TopBar(),
            _HeroSection(),
            _BenefitsSection(),
            _FeaturesSection(),
            _CallToActionSection(),
            _FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      color: theme.surfaceContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                themeNotifier.isDarkMode
                    ? "assets/img/logo128.png"
                    : "assets/img/logoClaro128.png",
                height: 48,
              ),
              const SizedBox(width: 12),
              Text(
                "BarbeariaFácil",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: theme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => context.go('/login'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.onSurface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text("Entrar", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => context.go('/cadastro'),
                child: const Text(
                  "Cadastrar-se",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.surface, theme.surfaceContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            Text(
              "Transforme sua barbearia com tecnologia",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: theme.primary,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Gestão simples, agendamentos automáticos e mais clientes satisfeitos.",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: theme.onSurface.withValues(alpha: 0.7),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => context.go('/cadastro'),
              child: const Text(
                "Experimente grátis",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitsSection extends StatelessWidget {
  const _BenefitsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        children: [
          Text(
            "Por que escolher nosso sistema?",
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 40,
            runSpacing: 40,
            children: const [
              _BenefitCard(
                icon: Icons.schedule,
                title: "Agendamento fácil",
                text:
                    "Seu cliente marca o horário pelo celular e você recebe tudo automaticamente, sem mensagens manuais.",
              ),
              _BenefitCard(
                icon: Icons.people_outline,
                title: "Fidelize clientes",
                text:
                    "Envie lembretes automáticos e mantenha sua barbearia sempre na mente do seu cliente.",
              ),
              _BenefitCard(
                icon: Icons.attach_money,
                title: "Mais lucro, menos erro",
                text:
                    "Evite horários vagos e organize sua equipe para atender mais clientes com eficiência.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _BenefitCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Icon(icon, color: theme.primary, size: 60),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: theme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      child: Column(
        children: [
          Text(
            "Tudo que sua barbearia precisa em um só lugar",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: theme.primary,
            ),
          ),
          const SizedBox(height: 50),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 40,
            runSpacing: 40,
            children: const [
              _FeatureItem(
                title: "Agenda inteligente",
                description:
                    "Visualize todos os horários e barbeiros em um calendário simples e prático.",
              ),
              _FeatureItem(
                title: "Controle financeiro",
                description:
                    "Acompanhe entradas, despesas e lucros em tempo real.",
              ),
              _FeatureItem(
                title: "Múltiplos barbeiros",
                description:
                    "Gerencie cada profissional com agenda e relatórios individuais.",
              ),
              _FeatureItem(
                title: "Notificações automáticas",
                description:
                    "Lembre o cliente do horário e reduza faltas com lembretes por WhatsApp.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final String title;
  final String description;

  const _FeatureItem({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: theme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallToActionSection extends StatelessWidget {
  const _CallToActionSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: theme.primary,
      child: Center(
        child: Column(
          children: [
            Text(
              "Leve sua barbearia para o próximo nível!",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.onPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Comece hoje mesmo a usar o sistema que vai facilitar sua rotina e impressionar seus clientes.",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 18,
                color: theme.onPrimary.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/cadastro'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text(
                "Criar conta grátis",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(40),
      color: Colors.black,
      child: Center(
        child: Text(
          "© ${DateTime.now().year} BarbeariaFácil — Simplificando o dia a dia da sua barbearia",
          style: GoogleFonts.openSans(
            color: theme.onPrimary.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
