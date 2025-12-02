import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NOVO: Import do Firebase Auth
// Import das páginas para navegação
import 'agendamento_page.dart';
import 'pontoDescarte_page.dart';
import 'login_page.dart'; // NOVO: Import da LoginPage para navegação após logout

// Modelo local simples para o carrossel
class Causa {
  final String name;
  final String logo;
  final String url;
  Causa({required this.name, required this.logo, required this.url});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String routePath = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // NOVO: Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Dados locais
  final List<Causa> causes = [
    Causa(
        name: 'IBAMA',
        logo: 'assets/ibamacausa.png',
        url: 'https://www.gov.br/ibama'),
    Causa(
        name: 'Ecobarreira',
        logo: 'assets/ecobarreira.png',
        url: 'https://www.ecobarreiradiluvio.com.br/'),
    Causa(
        name: 'SOS Amazônia',
        logo: 'assets/SOS-Amazonia-logo.png',
        url: 'https://sosamazonia.org.br'),
  ];

  int _currentIndex = 0;

  void _nextSlide() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % causes.length;
    });
  }

  void _prevSlide() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + causes.length) % causes.length;
    });
  }

  // Helper para abrir URL (Permanece igual)
  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Erro ao abrir URL: $e');
    }
  }

  // --- NOVO: FUNÇÃO DE LOGOUT DO FIREBASE ---
  Future<void> _signOut() async {
    try {
      await _auth.signOut();

      // Navegar para a tela de login (usando pushReplacementNamed para limpar a pilha)
      Navigator.pushReplacementNamed(context, LoginPage.routePath);

      // Opcional: Mostrar SnackBar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout realizado com sucesso!')),
      );
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao sair. Tente novamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCause = causes[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 95,
        // Logo Biosync
        title: Container(
          height: 95,
          padding: const EdgeInsets.only(top:16),
          child: Image.asset(
            'assets/logo-bio-sync-cadastro.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: _signOut, // ATUALIZADO: Chama a função _signOut
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // --- QUEM SOMOS ---
                  Text(
                    'Quem Somos?',
                    style: GoogleFonts.interTight(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A BIOSYNC conecta pessoas e promove a conscientização para um futuro sustentável, gerando oportunidades para coletores e facilitando o descarte correto.',
                    style: GoogleFonts.inter(
                        fontSize: 16, height: 1.5, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // --- CARDS DE NAVEGAÇÃO ---
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildNavCard(
                        label: "Pontos",
                        icon: Icons.location_on,
                        color: Colors.white,
                        onTap: () => Navigator.pushNamed(
                            context, PontoDescartePage.routePath),
                      ),
                      _buildNavCard(
                        label: "Agendar",
                        icon: Icons.calendar_month,
                        color: Colors.white,
                        onTap: () => Navigator.pushNamed(
                            context, AgendamentoPage.routePath),
                      ),
                      _buildNavCard(
                        label: "Notícias",
                        icon: Icons.newspaper,
                        color: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Área de notícias em breve!')));
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // --- CITAÇÃO ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                            left: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 4))),
                    child: Column(
                      children: [
                        Text(
                          '"A sustentabilidade cria e mantém as condições sob as quais humanos e natureza podem existir em equilíbrio."',
                          style: GoogleFonts.inter(
                              fontSize: 14, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '- Dr. Karl-Henrik Robèrt',
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // --- CARROSSEL DE CAUSAS ---
                  Text(
                    'Apoie Causas',
                    style: GoogleFonts.interTight(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _prevSlide,
                        icon: const Icon(Icons.chevron_left),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200]),
                      ),
                      Expanded(
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Tratamento de erro se a imagem não existir
                                SizedBox(
                                  height: 80,
                                  child: Image.asset(
                                    currentCause.logo,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.image,
                                                size: 50, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(currentCause.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _nextSlide,
                        icon: const Icon(Icons.chevron_right),
                        style: IconButton.styleFrom(
                            backgroundColor: Colors.grey[200]),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => _launchURL(currentCause.url),
                    child: const Text("Saiba mais"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar os botões de navegação (permanece igual)
  Widget _buildNavCard(
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 80, 225, 138),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}