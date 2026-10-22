import 'package:flutter/material.dart';

import '../models/caixa_dagua.dart';
import '../services/caixa_dagua_service.dart';

/// Formulário de cadastro/edição. Se receber uma caixa, edita; senão, cadastra.
class CaixaDAguaFormPage extends StatefulWidget {
  final CaixaDAgua? caixa;

  const CaixaDAguaFormPage({super.key, this.caixa});

  @override
  State<CaixaDAguaFormPage> createState() => _CaixaDAguaFormPageState();
}

class _CaixaDAguaFormPageState extends State<CaixaDAguaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = CaixaDAguaService();

  late final TextEditingController _marca;
  late final TextEditingController _modelo;
  late final TextEditingController _formato;
  late final TextEditingController _preco;
  late final TextEditingController _altura;
  late final TextEditingController _largura;
  late final TextEditingController _profundidade;

  Cor _cor = Cor.azulForte;
  MaterialCaixa _material = MaterialCaixa.polietileno;
  bool _salvando = false;

  bool get _editando => widget.caixa != null;

  @override
  void initState() {
    super.initState();
    final c = widget.caixa;
    String dim(int i) =>
        (c != null && c.dimensao.length > i) ? c.dimensao[i].toString() : '';

    _marca = TextEditingController(text: c?.marca ?? '');
    _modelo = TextEditingController(text: c?.modelo ?? '');
    _formato = TextEditingController(text: c?.formato ?? '');
    _preco = TextEditingController(text: c?.preco.toString() ?? '');
    _altura = TextEditingController(text: dim(0));
    _largura = TextEditingController(text: dim(1));
    _profundidade = TextEditingController(text: dim(2));
    if (c != null) {
      _cor = c.cor;
      _material = c.material;
    }
  }

  @override
  void dispose() {
    for (final c in [
      _marca,
      _modelo,
      _formato,
      _preco,
      _altura,
      _largura,
      _profundidade,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _numero(TextEditingController c) =>
      double.parse(c.text.trim().replaceAll(',', '.'));

  String? _obrigatorio(String? valor) =>
      (valor == null || valor.trim().isEmpty) ? 'Campo obrigatório' : null;

  String? _validarNumero(String? valor) {
    if (_obrigatorio(valor) != null) return 'Campo obrigatório';
    final n = double.tryParse(valor!.trim().replaceAll(',', '.'));
    if (n == null || n <= 0) return 'Informe um número maior que zero';
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final caixa = CaixaDAgua(
      id: widget.caixa?.id,
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      dimensao: [_numero(_altura), _numero(_largura), _numero(_profundidade)],
      cor: _cor,
      material: _material,
      formato: _formato.text.trim(),
      preco: _numero(_preco),
    );

    setState(() => _salvando = true);
    try {
      if (_editando) {
        await _service.atualizar(caixa);
      } else {
        await _service.salvar(caixa);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Widget _campo(
    TextEditingController controller,
    String rotulo, {
    bool numerico = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: rotulo,
        border: const OutlineInputBorder(),
      ),
      keyboardType: numerico
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      validator: numerico ? _validarNumero : _obrigatorio,
    );
  }

  @override
  Widget build(BuildContext context) {
    const espaco = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar caixa d\'água' : 'Nova caixa d\'água'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _campo(_marca, 'Marca'),
            espaco,
            _campo(_modelo, 'Modelo'),
            espaco,
            _campo(_formato, 'Formato'),
            espaco,
            Text('Dimensão', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _campo(_altura, 'Altura', numerico: true)),
                const SizedBox(width: 8),
                Expanded(child: _campo(_largura, 'Largura', numerico: true)),
                const SizedBox(width: 8),
                Expanded(
                  child: _campo(_profundidade, 'Profundidade', numerico: true),
                ),
              ],
            ),
            espaco,
            DropdownButtonFormField<Cor>(
              initialValue: _cor,
              decoration: const InputDecoration(
                labelText: 'Cor',
                border: OutlineInputBorder(),
              ),
              items: Cor.values
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c.descricao)))
                  .toList(),
              onChanged: (c) => setState(() => _cor = c!),
            ),
            espaco,
            DropdownButtonFormField<MaterialCaixa>(
              initialValue: _material,
              decoration: const InputDecoration(
                labelText: 'Material',
                border: OutlineInputBorder(),
              ),
              items: MaterialCaixa.values
                  .map((m) =>
                      DropdownMenuItem(value: m, child: Text(m.descricao)))
                  .toList(),
              onChanged: (m) => setState(() => _material = m!),
            ),
            espaco,
            _campo(_preco, 'Preço (R\$)', numerico: true),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: _salvando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
