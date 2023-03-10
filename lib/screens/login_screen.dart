import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/screens/tabs_screen.dart';
import 'package:lista_tarefas/services/message_scaffold.dart';

import '../screens/register_screen.dart';
import 'package:flutter/material.dart';
import '../screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Variável para logar no firebase;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    // Logar no firebase com usuário e senha;
    _auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((value) {
      // Salvar dados do usuário no dispositivo. Passado o uid para o 'token' da storage. Podendo comparar na tela SplashScreen;
      GetStorage().write('token', value.user!.uid);
      // Armazena no dispositivo o email do usuário para usar no FirestoreRepository para criar uma coleção;
      GetStorage().write('email', value.user!.email);
      Navigator.pushReplacementNamed(context, TabsScreen.id);
      MessageScaffold.showMessage(
          context, 'Login realizado com sucesso!', Colors.green);
    }).onError((e, s) {
      MessageScaffold.showMessage(
          context, 'Erro ao realizar login!', Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entrar'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Insira seus dados para realizar o login!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email é obrigatório!';
                      } else if (!value.contains('@')) {
                        return 'Digite um e-mail válido!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha é obrigatório!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Entrar'),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RegisterScreen.id);
                      },
                      child: const Text('Não tem conta? Registe-se')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ForgotPasswordScreen.id);
                      },
                      child: const Text('Recuperar Senha')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
