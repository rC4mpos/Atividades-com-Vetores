import 'package:flutter/material.dart';

import 'views/caixa_dagua_list_page.dart';

void main() {
  runApp(const GerenciadorCaixasApp());
}

class GerenciadorCaixasApp extends StatelessWidget {
  const GerenciadorCaixasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Caixas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      home: const CaixaDAguaListPage(),
    );
  }
}
