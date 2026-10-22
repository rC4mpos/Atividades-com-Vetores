import 'package:flutter/material.dart';

import '../models/caixa_dagua.dart';
import '../services/caixa_dagua_service.dart';
import 'caixa_dagua_form_page.dart';

/// Tela principal: lista as caixas d'água cadastradas.
class CaixaDAguaListPage extends StatefulWidget {
  const CaixaDAguaListPage({super.key});

  @override
  State<CaixaDAguaListPage> createState() => _CaixaDAguaListPageState();
}

class _CaixaDAguaListPageState extends State<CaixaDAguaListPage> {
  final _service = CaixaDAguaService();
  late Future<List<CaixaDAgua>> _caixas;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  void _carregar() {
    setState(() {
      _caixas = _service.listar();
    });
  }

  Future<void> _abrirFormulario([CaixaDAgua? caixa]) async {
    final salvou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CaixaDAguaFormPage(caixa: caixa)),
    );
    if (salvou == true) _carregar();
  }

  Future<void> _excluir(CaixaDAgua caixa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir caixa d\'água'),
        content: Text('Deseja excluir ${caixa.marca} ${caixa.modelo}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    try {
      await _service.excluir(caixa.id!);
      _carregar();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao excluir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caixas d\'água'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: _carregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nova'),
      ),
      body: FutureBuilder<List<CaixaDAgua>>(
        future: _caixas,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Erro ao carregar: ${snapshot.error}',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _carregar,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final caixas = snapshot.data!;
          if (caixas.isEmpty) {
            return const Center(
                child: Text('Nenhuma caixa d\'água cadastrada.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: caixas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final caixa = caixas[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.water_drop)),
                title: Text('${caixa.marca} - ${caixa.modelo}'),
                subtitle: Text(
                  '${caixa.material.descricao} • ${caixa.cor.descricao} • '
                  '${caixa.formato}\n'
                  'Dimensão: ${caixa.dimensao.join(' x ')}',
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('R\$ ${caixa.preco.toStringAsFixed(2)}'),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Excluir',
                      onPressed: () => _excluir(caixa),
                    ),
                  ],
                ),
                onTap: () => _abrirFormulario(caixa),
              );
            },
          );
        },
      ),
    );
  }
}
