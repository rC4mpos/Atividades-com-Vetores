import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/caixa_dagua.dart';

/// Faz as chamadas HTTP para o CaixaDAguaController do backend.
class CaixaDAguaService {
  /// Pode ser alterado com --dart-define=API_URL=http://10.0.2.2:8080
  /// (10.0.2.2 é o localhost da máquina visto pelo emulador Android).
  static const String baseUrl =
      String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');

  final http.Client _client;

  CaixaDAguaService({http.Client? client}) : _client = client ?? http.Client();

  Uri _uri([int? id]) =>
      Uri.parse(id == null ? '$baseUrl/caixas-dagua' : '$baseUrl/caixas-dagua/$id');

  static const _headers = {'Content-Type': 'application/json'};

  Future<List<CaixaDAgua>> listar() async {
    final resposta = await _client.get(_uri());
    _verificar(resposta);
    final lista = jsonDecode(utf8.decode(resposta.bodyBytes)) as List;
    return lista
        .map((e) => CaixaDAgua.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<CaixaDAgua> salvar(CaixaDAgua caixa) async {
    final resposta = await _client.post(
      _uri(),
      headers: _headers,
      body: jsonEncode(caixa.toJson()),
    );
    _verificar(resposta);
    return CaixaDAgua.fromJson(jsonDecode(utf8.decode(resposta.bodyBytes)));
  }

  Future<CaixaDAgua> atualizar(CaixaDAgua caixa) async {
    final resposta = await _client.put(
      _uri(caixa.id),
      headers: _headers,
      body: jsonEncode(caixa.toJson()),
    );
    _verificar(resposta);
    return CaixaDAgua.fromJson(jsonDecode(utf8.decode(resposta.bodyBytes)));
  }

  Future<void> excluir(int id) async {
    final resposta = await _client.delete(_uri(id));
    _verificar(resposta);
  }

  void _verificar(http.Response resposta) {
    if (resposta.statusCode < 200 || resposta.statusCode >= 300) {
      throw Exception('Erro ${resposta.statusCode} ao acessar a API');
    }
  }
}
