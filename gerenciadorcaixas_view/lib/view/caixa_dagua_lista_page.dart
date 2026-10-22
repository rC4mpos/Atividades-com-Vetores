import 'package:flutter/material.dart';

import '../model/caixa_dagua.dart';
import '../service/caixa_dagua_service.dart';
import 'caixa_dagua_form_page.dart';

// Tela principal: lista as caixas d'água cadastradas no backend
class CaixaDAguaListaPage extends StatefulWidget {
  const CaixaDAguaListaPage({super.key});

  @override
  State<CaixaDAguaListaPage> createState() => _CaixaDAguaListaPageState();
}

class _CaixaDAguaListaPageState extends State<CaixaDAguaListaPage> {
  final _service = CaixaDAguaService();
  late Future<List<CaixaDAgua>> _caixas;

  @override
  void initState() {
    super.initState();
    _caixas = _service.listar();
  }

  void _recarregar() {
    setState(() {
      _caixas = _service.listar();
    });
  }

  // Abre o formulário. Sem caixa = cadastro, com caixa = edição.
  Future<void> _abrirFormulario([CaixaDAgua? caixa]) async {
    final salvou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CaixaDAguaFormPage(caixa: caixa)),
    );
    if (salvou == true) _recarregar();
  }

  Future<void> _excluir(CaixaDAgua caixa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir caixa'),
        content: Text('Deseja excluir a caixa ${caixa.marca} ${caixa.modelo}?'),
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
      _mostrarMensagem('Caixa excluída');
      _recarregar();
    } catch (e) {
      _mostrarMensagem(e.toString());
    }
  }

  void _mostrarMensagem(String mensagem) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensagem)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caixas d'Água"),
        actions: [
          IconButton(
            tooltip: 'Atualizar',
            icon: const Icon(Icons.refresh),
            onPressed: _recarregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nova caixa'),
      ),
      body: FutureBuilder<List<CaixaDAgua>>(
        future: _caixas,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _ErroConexao(onTentarNovamente: _recarregar);
          }

          final caixas = snapshot.data!;
          if (caixas.isEmpty) {
            return const Center(
              child: Text('Nenhuma caixa cadastrada.\nClique em "Nova caixa".',
                  textAlign: TextAlign.center),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: caixas.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final caixa = caixas[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.water_drop)),
                title: Text('${caixa.marca} ${caixa.modelo}'),
                subtitle: Text(
                  '${caixa.material.descricao} • ${caixa.cor.descricao} • '
                  '${caixa.formato}\n'
                  'Dimensão: ${caixa.dimensao.join(' x ')} m',
                ),
                isThreeLine: true,
                onTap: () => _abrirFormulario(caixa),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'R\$ ${caixa.preco.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      tooltip: 'Excluir',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _excluir(caixa),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ErroConexao extends StatelessWidget {
  final VoidCallback onTentarNovamente;

  const _ErroConexao({required this.onTentarNovamente});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Não foi possível conectar ao backend.\n'
              'Verifique se o Spring Boot está rodando na porta 8080.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onTentarNovamente,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
