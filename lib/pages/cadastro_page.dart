import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// NOVO: Importa a LoginPage para navegação de volta (Login)
import 'login_page.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  static const String routePath = '/cadastro';

  @override
  Widget build(BuildContext context) {
    // Cor do tema para o link de login
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      // NOVO: Adiciona um AppBar
      appBar: AppBar(
        backgroundColor: Colors
            .transparent, // Transparente para deixar o gradiente do corpo visível
        elevation: 0,
        foregroundColor: Colors
            .white, // Ícone de voltar branco para contrastar com o cabeçalho
      ),
      // NOVO: Adiciona a propriedade extendBodyBehindAppBar para que o corpo vá até o topo
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. CABEÇALHO (HEADER) ---
            Container(
              width: double.infinity,
              // Mantém a altura para dar espaço ao conteúdo abaixo da AppBar
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF50E18A),
                    Color(0xFF2E7D32)
                  ], // Usando o verde do tema
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      child: Image.asset(
                        'assets/logo-bio-sync-login.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Cadastro', // Renomeado para Biosync
                      style: GoogleFonts.interTight(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // --- 2. CORPO (OPÇÕES) ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'Bem-vindo ao Biosync', // Renomeado
                    textAlign: TextAlign.center,
                    style: GoogleFonts.interTight(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101213),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Escolha como você gostaria de contribuir para um mundo mais sustentável:',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF57636C),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // OPÇÃO 1: MORADOR
                  _buildSelectionCard(
                    context: context,
                    title: 'Sou Morador',
                    subtitle: 'Agende coletas de recicláveis em sua casa',
                    icon: Icons.home_rounded,
                    color: primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, '/formRegisterCommunity');
                    },
                  ),

                  const SizedBox(height: 16),

                  // OPÇÃO 2: COLETOR
                  _buildSelectionCard(
                    context: context,
                    title: 'Sou Coletor',
                    subtitle: 'Realize coletas e organize sua rota diária',
                    icon: Icons.local_shipping_rounded,
                    color: primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, '/formRegisterCollector');
                    },
                  ),

                  const SizedBox(height: 16),

                  // OPÇÃO 3: PONTO DE DESCARTE
                  _buildSelectionCard(
                    context: context,
                    title: 'Ponto de Descarte',
                    subtitle: 'Gerencie um ponto de coleta de recicláveis',
                    icon: Icons.location_on_rounded,
                    color: primaryColor,
                    onTap: () {
                      Navigator.pushNamed(context, '/formRegisterDisposal');
                    },
                  ),

                  const SizedBox(height: 32),

                  // --- 3. RODAPÉ (LOGIN LINK) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem uma conta? ',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF57636C),
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navega para a LoginPage usando a rota nomeada
                          Navigator.pushNamed(context, LoginPage.routePath);
                        },
                        child: Text(
                          'Entrar',
                          style: GoogleFonts.inter(
                            color: primaryColor, // Verde do tema
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET AUXILIAR (CARD REUTILIZÁVEL) ---
  Widget _buildSelectionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Ícone Circular
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.interTight(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF101213),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF57636C),
                      ),
                    ),
                  ],
                ),
              ),
              // Ícone de seta para indicar ação
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}