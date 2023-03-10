import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lista_tarefas/screens/login_screen.dart';
import 'package:lista_tarefas/services/message_scaffold.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static const id = 'forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Variável para recuperar a senha;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    // Enviar email de redifinição de senha;
    await _auth
        .sendPasswordResetEmail(email: _emailController.text.trim())
        .then((value) {
      Navigator.pushReplacementNamed(context, LoginScreen.id);
      MessageScaffold.showMessage(
          context, 'Verifique seu email!', Colors.green);
    }).onError((e, s) {
      MessageScaffold.showMessage(context, 'Ocorreu um erro!', Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir Senha'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Insira seus email para redefinir a senha!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Digite seu e-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email é obrigatório!';
                      } else if (!value.contains('@')) {
                        return 'Digite um e-mail válido!';
                      }
                      return null;
                    },
                    controller: _emailController,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.mail_outline),
                      label: const Text("Redefinir Senha"),
                    ),
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width * 0.7,
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //         minimumSize: const Size(100, 40),
                  //         maximumSize: const Size(200, 40)),
                  //     onPressed: () async {
                  //       _formKey.currentState!.validate();
                  //     },
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: const [
                  //         Icon(Icons.mail_outline),
                  //         SizedBox(width: 10),
                  //         Text("Redefinir Senha")
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
