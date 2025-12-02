import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // NOVO: Import do Firebase Auth

// Import das suas rotas (Assumindo que você definiu as rotas conforme a sugestão)
import 'package:biosync/pages/home_page.dart';
import 'package:biosync/pages/cadastro_page.dart';

class LoginPage extends StatefulWidget {
  // NOVO: Adicione o routePath estático para uso no MaterialApp
  static const String routePath = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Instância do Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variáveis de Estado
  bool _passwordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false; // NOVO: Para desabilitar o botão e mostrar progresso

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- NOVO: FUNÇÃO DE AUTENTICAÇÃO COM FIREBASE ---
  Future<void> _signInWithEmailAndPassword() async {
    // 1. Validar e-mail e senha
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Chamar o método de login do Firebase
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // 3. Sucesso: Navegar para a Home Page
      _showSnackBar(
          'Login bem-sucedido!', Theme.of(context).colorScheme.primary);

      // Usa o nome da rota da sua HomePage (definido em main.dart ou na HomePage)
      Navigator.pushReplacementNamed(context, HomePage.routePath);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Ocorreu um erro. Tente novamente.';

      // 4. Tratar Erros Específicos do Firebase
      if (e.code == 'user-not-found') {
        errorMessage = 'Nenhum usuário encontrado para este e-mail.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Senha incorreta. Tente novamente.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Formato de e-mail inválido.';
      }
      _showSnackBar(errorMessage, Colors.red);
      print('Erro de Autenticação Firebase: ${e.code}');
    } catch (e) {
      // 5. Tratar outros erros
      _showSnackBar('Ocorreu um erro desconhecido.', Colors.red);
      print('Erro Desconhecido: $e');
    } finally {
      setState(() {
        _isLoading = false; // 6. Remover o estado de carregamento
      });
    }
  }

  // Função auxiliar para exibir mensagens (SnackBar)
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ... (Seus TÍTULOS e CAMPOS DE TEXTO permanecem iguais) ...
                // --- TÍTULOS ---
                const Text(
                  'Bem-vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101518),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre na sua conta para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF57636C),
                  ),
                ),
                const SizedBox(height: 32),

                // --- CAMPOS DE TEXTO ---
                TextFormField(
                  style: const TextStyle(color: Colors.black54),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.black54),
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // --- LEMBRAR DE MIM & ESQUECI SENHA ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Lembrar de mim'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Lógica de esqueceu a senha
                      },
                      child: const Text(
                        'Esqueceu a senha?',
                        style: TextStyle(color: Color(0xFF57636C)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- BOTÃO ENTRAR (Integrado com Firebase) ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // NOVO: Chama a função de autenticação
                    onPressed: _isLoading ? null : _signInWithEmailAndPassword,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Entrar'),
                  ),
                ),

                const SizedBox(height: 32),

                // --- DIVISOR "OU CONTINUE COM" ---
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('ou continue com',
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // --- BOTÕES SOCIAIS ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _socialButton(
                      imagePath: 'assets/google.png',
                      onTap: () {
                        // Implementar Google Sign-In aqui
                        _showSnackBar(
                            'Google Sign-In em desenvolvimento', Colors.black87);
                      },
                    ),
                    _socialButton(
                      imagePath: 'assets/linkedin.png',
                      onTap: () => _showSnackBar(
                          'LinkedIn Sign-In em desenvolvimento', Colors.black87),
                    ),
                    _socialButton(
                      imagePath: 'assets/github-logo.png',
                      onTap: () => _showSnackBar(
                          'Github Sign-In em desenvolvimento', Colors.black87),
                    ),
                    _socialButton(
                      imagePath: 'assets/instagram.png',
                      onTap: () => _showSnackBar(
                          'Instagram Sign-In em desenvolvimento', Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- RODAPÉ CADASTRE-SE ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta? ',
                      style: TextStyle(color: Color(0xFF57636C)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navegar para a tela de menu de Cadastro usando a rota nomeada
                        Navigator.pushNamed(context, CadastroPage.routePath);
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar os botões sociais (permanece igual)
  Widget _socialButton(
      {required String imagePath,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(padding: const EdgeInsets.all(12),
        child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (context, error, StackTrace) => const Icon(Icons.error, color: Color.fromARGB(255, 255, 0, 0),),)),
      ),
    );
  }
}