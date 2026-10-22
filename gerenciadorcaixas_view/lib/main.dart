import 'package:flutter/material.dart';

import 'view/caixa_dagua_lista_page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CaixaDAguaListaPage(),
    );
  }
}
