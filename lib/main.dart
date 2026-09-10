import 'package:flutter/material.dart';

import 'core/constants/app_colors.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const AgendaApp());
}

class AgendaApp extends StatelessWidget {
  const AgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestor de Agenda',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink),
        scaffoldBackgroundColor: AppColors.coral,
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const LoginPage(),
    ); 
  }
}
