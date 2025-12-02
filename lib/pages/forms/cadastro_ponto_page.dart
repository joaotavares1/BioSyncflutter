import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroPontoPage extends StatefulWidget {
  const CadastroPontoPage({super.key});

  @override
  State<CadastroPontoPage> createState() => _CadastroPontoPageState();
}

class _CadastroPontoPageState extends State<CadastroPontoPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controladores Gerais
  final descricaoController = TextEditingController(); // "Nome do Local" -> Salvo como descricao
  final cnpjController = TextEditingController();
  final celularController = TextEditingController();
  
  // Login
  final emailController = TextEditingController();
  final passController = TextEditingController();

  // Endereço
  final cepController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();

  Future<void> _cadastrarPonto() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1. Cria Login
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 2. Monta o Mapa de Endereço (Igual ao seu print)
      Map<String, dynamic> enderecoMap = {
        'cep': cepController.text.trim(),
        'rua': ruaController.text.trim(),
        'numero': int.tryParse(numeroController.text.trim()) ?? 0,
        'bairro': bairroController.text.trim(),
        'cidade': cidadeController.text.trim(),
        'estado': estadoController.text.trim(),
        'nacao': 'Brasil', // Valor padrão ou adicione um campo se quiser
      };

      // 3. Salva no Firestore (Coleção 'pontosDeDescarte')
      await FirebaseFirestore.instance.collection('pontosDeDescarte').doc(uid).set({
        'descricao': descricaoController.text.trim(),
        'cnpj': cnpjController.text.trim(),
        'celular': celularController.text.trim(),
        'email': emailController.text.trim(),
        'endereco': enderecoMap, // Mapa aninhado
        // 'tipo' removido para ficar igual ao seu print, mas o app saberá que é ponto pela coleção
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ponto registrado com sucesso!')),
        );
        
        // CORREÇÃO: Força a ida para a Home limpa o histórico
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao cadastrar.';
      if (e.code == 'email-already-in-use') msg = 'E-mail já utilizado.';
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Novo Ponto de Descarte'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Dados do Local", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Nome do Local (Descrição)', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: celularController,
                decoration: const InputDecoration(labelText: 'Celular', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 24),
              const Text("Endereço", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),

              TextFormField(
                controller: cepController,
                decoration: const InputDecoration(labelText: 'CEP', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: ruaController,
                      decoration: const InputDecoration(labelText: 'Rua', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: numeroController,
                      decoration: const InputDecoration(labelText: 'Nº', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: bairroController,
                decoration: const InputDecoration(labelText: 'Bairro', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: cidadeController,
                      decoration: const InputDecoration(labelText: 'Cidade', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: estadoController,
                      decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text("Acesso (Login)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.contains('@') ? null : 'Email inválido',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(labelText: 'Senha', border: OutlineInputBorder()),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _cadastrarPonto,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Cadastrar Ponto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}