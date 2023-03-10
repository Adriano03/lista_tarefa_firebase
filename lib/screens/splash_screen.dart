import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lista_tarefas/screens/login_screen.dart';
import 'package:lista_tarefas/screens/tabs_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage _getStorage = GetStorage();

  @override
  void initState() {
    openNextPage(context);
    super.initState();
  }

  // Função para controlar qual página o usuário será redirecionado conforme se está logado ou não;
  void openNextPage(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      // Na tela de login_screen foi armazenado o uid do usuário no getStorage;
      // Então sempre que entrar no app vai fazer a verificação se o usuário está logado manda Tabs senão Login;
      if (_getStorage.read('token') == null ||
          _getStorage.read('token') == '') {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      } else {
        Navigator.pushReplacementNamed(context, TabsScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
