import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroUsuarioPage extends StatefulWidget {
  final String tipoUsuario; // "Morador" ou "Coletor"

  const CadastroUsuarioPage({super.key, required this.tipoUsuario});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // 1. Cria a conta de Autenticação (Isso faz o login automático)
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 2. Salva os dados no Firestore (Coleção 'usuario')
      // Atenção: As regras de segurança agora permitem isso porque o UID do doc é igual ao do usuário logado.
      await FirebaseFirestore.instance.collection('usuario').doc(uid).set({
        'nome': nameController.text.trim(),
        'email': emailController.text.trim(),
        'senha': passController.text.trim(), // Salvando senha visível (conforme seu print)
        // O campo 'tipo' não está no seu print, mas é útil para o app saber quem é.
        // Se quiser remover, basta apagar a linha abaixo.
        'tipo': widget.tipoUsuario, 
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.tipoUsuario} cadastrado com sucesso!')),
        );
        
        // CORREÇÃO: Em vez de voltar, força a ida para a Home e apaga o histórico anterior
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro desconhecido.';
      if (e.code == 'email-already-in-use') msg = 'E-mail já cadastrado.';
      if (e.code == 'weak-password') msg = 'Senha muito fraca (mínimo 6 dígitos).';
      
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
        title: Text('Cadastro de ${widget.tipoUsuario}'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.contains('@') ? null : 'Email inválido',
              ),
              const SizedBox(height: 16),
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
                  onPressed: _isLoading ? null : _cadastrar,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}