import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_html/html.dart' as html;
import 'package:go_router/go_router.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    html.document.title = 'BarbeariaApp - Plataforma de Agendamento para Barbearias';
    return Scaffold(
      backgroundColor: const Color(0xFF181818), // fundo escuro
      body: SingleChildScrollView(
        child: Column(
          children: const [
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      color: const Color(0xFF232323), // barra escura
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo e nome
          Row(
            children: [
              Image.asset(
                "assets/img/logo.png",
                height: 48,
              ),
              const SizedBox(width: 12),
              Text(
                "BarbeariaApp",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // Botões de ação
          Row(
            children: [
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[200],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Entrar", style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                   context.go('/cadastro');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child:
                    const Text("Cadastrar-se", style: TextStyle(fontSize: 16)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF232323), Color(0xFF181818)],
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
                color: Colors.orangeAccent[700],
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Gestão simples, agendamentos automáticos e mais clientes satisfeitos.",
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.grey[300],
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {context.go('/cadastro');},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent[700],
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Experimente grátis",
                style: TextStyle(fontSize: 18, color: Colors.white),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      color: Color(0xFF232323),
      child: Center(
        child: Column(
          children: [
            Text(
              "Por que escolher nosso sistema?",
              style: GoogleFonts.montserrat(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent[700],
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
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Icon(icon, color: Colors.orangeAccent[700], size: 60),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(fontSize: 16, color: Colors.grey[400]),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      decoration: const BoxDecoration(color: Color(0xFF181818)),
      child: Column(
        children: [
          Text(
            "Tudo que sua barbearia precisa em um só lugar",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent[700],
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

  const _FeatureItem({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.openSans(fontSize: 16, color: Colors.grey[400]),
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
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
        color: Colors.orangeAccent[700],
        child: Center(
          child: Column(
            children: [
              Text(
                "Leve sua barbearia para o próximo nível!",
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Comece hoje mesmo a usar o sistema que vai facilitar sua rotina e impressionar seus clientes.",
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  context.go('/cadastro');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Criar conta grátis",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: Colors.black,
      child: Center(
        child: Text(
          "© ${DateTime.now().year} BarberApp — Simplificando o dia a dia da sua barbearia",
          style: GoogleFonts.openSans(color: Colors.grey[500], fontSize: 14),
        ),
      ),
    );
  }
}
