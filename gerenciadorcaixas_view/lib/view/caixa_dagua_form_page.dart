// 'value' nos dropdowns funciona em versões antigas e novas do Flutter
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../model/caixa_dagua.dart';
import '../service/caixa_dagua_service.dart';

// Formulário de cadastro e edição de caixa d'água
class CaixaDAguaFormPage extends StatefulWidget {
  // null = cadastro novo, preenchido = edição
  final CaixaDAgua? caixa;

  const CaixaDAguaFormPage({super.key, this.caixa});

  @override
  State<CaixaDAguaFormPage> createState() => _CaixaDAguaFormPageState();
}

class _CaixaDAguaFormPageState extends State<CaixaDAguaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _service = CaixaDAguaService();

  final _marca = TextEditingController();
  final _modelo = TextEditingController();
  final _altura = TextEditingController();
  final _largura = TextEditingController();
  final _profundidade = TextEditingController();
  final _formato = TextEditingController();
  final _preco = TextEditingController();

  Cor _cor = Cor.AZUL_FORTE;
  MaterialCaixa _material = MaterialCaixa.POLIETILENO;
  bool _salvando = false;

  bool get _editando => widget.caixa != null;

  @override
  void initState() {
    super.initState();
    final caixa = widget.caixa;
    if (caixa != null) {
      _marca.text = caixa.marca;
      _modelo.text = caixa.modelo;
      _formato.text = caixa.formato;
      _preco.text = caixa.preco.toStringAsFixed(2);
      _cor = caixa.cor;
      _material = caixa.material;

      final controllersDimensao = [_altura, _largura, _profundidade];
      for (var i = 0; i < caixa.dimensao.length && i < 3; i++) {
        controllersDimensao[i].text = caixa.dimensao[i].toString();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in [
      _marca, _modelo, _altura, _largura, _profundidade, _formato, _preco,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  // Aceita vírgula ou ponto como separador decimal
  double? _lerNumero(String texto) =>
      double.tryParse(texto.trim().replaceAll(',', '.'));

  String? _obrigatorio(String? valor) =>
      (valor == null || valor.trim().isEmpty) ? 'Campo obrigatório' : null;

  String? _numeroPositivo(String? valor) {
    final numero = _lerNumero(valor ?? '');
    if (numero == null) return 'Informe um número';
    if (numero <= 0) return 'Deve ser maior que zero';
    return null;
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final caixa = CaixaDAgua(
      id: widget.caixa?.id,
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      dimensao: [
        _lerNumero(_altura.text)!,
        _lerNumero(_largura.text)!,
        _lerNumero(_profundidade.text)!,
      ],
      cor: _cor,
      material: _material,
      formato: _formato.text.trim(),
      preco: _lerNumero(_preco.text)!,
    );

    setState(() => _salvando = true);
    try {
      if (_editando) {
        await _service.atualizar(caixa);
      } else {
        await _service.cadastrar(caixa);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _salvando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    const espaco = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar caixa' : 'Nova caixa'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _marca,
              decoration: const InputDecoration(
                  labelText: 'Marca', border: OutlineInputBorder()),
              validator: _obrigatorio,
            ),
            espaco,
            TextFormField(
              controller: _modelo,
              decoration: const InputDecoration(
                  labelText: 'Modelo', border: OutlineInputBorder()),
              validator: _obrigatorio,
            ),
            espaco,
            Text('Dimensão (metros)',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _campoNumero(_altura, 'Altura')),
                const SizedBox(width: 8),
                Expanded(child: _campoNumero(_largura, 'Largura')),
                const SizedBox(width: 8),
                Expanded(child: _campoNumero(_profundidade, 'Profund.')),
              ],
            ),
            espaco,
            DropdownButtonFormField<Cor>(
              value: _cor,
              decoration: const InputDecoration(
                  labelText: 'Cor', border: OutlineInputBorder()),
              items: Cor.values
                  .map((cor) =>
                      DropdownMenuItem(value: cor, child: Text(cor.descricao)))
                  .toList(),
              onChanged: (valor) => setState(() => _cor = valor!),
            ),
            espaco,
            DropdownButtonFormField<MaterialCaixa>(
              value: _material,
              decoration: const InputDecoration(
                  labelText: 'Material', border: OutlineInputBorder()),
              items: MaterialCaixa.values
                  .map((material) => DropdownMenuItem(
                      value: material, child: Text(material.descricao)))
                  .toList(),
              onChanged: (valor) => setState(() => _material = valor!),
            ),
            espaco,
            TextFormField(
              controller: _formato,
              decoration: const InputDecoration(
                  labelText: 'Formato (ex.: Redonda, Retangular)',
                  border: OutlineInputBorder()),
              validator: _obrigatorio,
            ),
            espaco,
            _campoNumero(_preco, 'Preço (R\$)'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: _salvando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              label: Text(_editando ? 'Salvar alterações' : 'Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _campoNumero(TextEditingController controller, String rotulo) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration:
          InputDecoration(labelText: rotulo, border: const OutlineInputBorder()),
      validator: _numeroPositivo,
    );
  }
}
