import 'package:flutter/material.dart';
import 'package:lista_tarefas/screens/recycle_bin.dart';
import 'package:lista_tarefas/screens/tabs_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RecycleBin.id:
        return MaterialPageRoute(
          builder: (_) => const RecycleBin(),
        );
      case TabsScreen.id:
        return MaterialPageRoute(
          builder: (_) =>  const TabsScreen(),
        );
      default:
        return null;
    }
  }
}
