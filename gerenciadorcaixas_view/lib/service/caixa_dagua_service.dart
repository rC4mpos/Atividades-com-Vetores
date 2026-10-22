import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/caixa_dagua.dart';

// Faz as chamadas HTTP para o CaixaDAguaController do backend
class CaixaDAguaService {
  // No emulador Android o "localhost" do computador é 10.0.2.2.
  // No navegador (Chrome) e no Windows é localhost mesmo.
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/caixas-dagua';
    }
    return 'http://localhost:8080/caixas-dagua';
  }

  static const _headers = {'Content-Type': 'application/json'};

  // O client pode ser trocado nos testes por um falso (MockClient)
  final http.Client _client;

  CaixaDAguaService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<CaixaDAgua>> listar() async {
    final resposta = await _client.get(Uri.parse(baseUrl));
    _verificar(resposta, 'listar as caixas');

    final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List<dynamic>;
    return lista
        .map((item) => CaixaDAgua.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<CaixaDAgua> cadastrar(CaixaDAgua caixa) async {
    final resposta = await _client.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode(caixa.toJson()),
    );
    _verificar(resposta, 'cadastrar a caixa');
    return CaixaDAgua.fromJson(jsonDecode(utf8.decode(resposta.bodyBytes)));
  }

  Future<CaixaDAgua> atualizar(CaixaDAgua caixa) async {
    final resposta = await _client.put(
      Uri.parse('$baseUrl/${caixa.id}'),
      headers: _headers,
      body: jsonEncode(caixa.toJson()),
    );
    _verificar(resposta, 'atualizar a caixa');
    return CaixaDAgua.fromJson(jsonDecode(utf8.decode(resposta.bodyBytes)));
  }

  Future<void> excluir(int id) async {
    final resposta = await _client.delete(Uri.parse('$baseUrl/$id'));
    _verificar(resposta, 'excluir a caixa');
  }

  void _verificar(http.Response resposta, String acao) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception('Erro ao $acao (HTTP ${resposta.statusCode})');
    }
  }
}
