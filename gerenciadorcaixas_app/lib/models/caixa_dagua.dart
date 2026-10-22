/// Espelha o enum Cor do backend.
enum Cor {
  azulForte('AZUL_FORTE', 'Azul forte'),
  azulFraco('AZUL_FRACO', 'Azul fraco'),
  branco('BRANCO', 'Branco'),
  cinza('CINZA', 'Cinza');

  const Cor(this.valor, this.descricao);

  /// Valor enviado/recebido na API (nome do enum no Kotlin).
  final String valor;
  final String descricao;

  static Cor fromValor(String valor) =>
      Cor.values.firstWhere((c) => c.valor == valor);
}

/// Espelha o enum Material do backend.
/// Chamado de MaterialCaixa para não conflitar com o widget Material do Flutter.
enum MaterialCaixa {
  polietileno('POLIETILENO', 'Polietileno'),
  fibraDeVidro('FIBRA_DE_VIDRO', 'Fibra de vidro'),
  inox('INOX', 'Inox');

  const MaterialCaixa(this.valor, this.descricao);

  final String valor;
  final String descricao;

  static MaterialCaixa fromValor(String valor) =>
      MaterialCaixa.values.firstWhere((m) => m.valor == valor);
}

class CaixaDAgua {
  final int? id;
  final String marca;
  final String modelo;

  /// Dimensão (altura, largura, profundidade)
  final List<double> dimensao;
  final Cor cor;
  final MaterialCaixa material;
  final String formato;
  final double preco;

  CaixaDAgua({
    this.id,
    required this.marca,
    required this.modelo,
    required this.dimensao,
    required this.cor,
    required this.material,
    required this.formato,
    required this.preco,
  });

  factory CaixaDAgua.fromJson(Map<String, dynamic> json) => CaixaDAgua(
        id: json['id'] as int?,
        marca: json['marca'] as String,
        modelo: json['modelo'] as String,
        dimensao: ((json['dimensao'] as List?) ?? [])
            .map((d) => (d as num).toDouble())
            .toList(),
        cor: Cor.fromValor(json['cor'] as String),
        material: MaterialCaixa.fromValor(json['material'] as String),
        formato: json['formato'] as String,
        preco: (json['preco'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'marca': marca,
        'modelo': modelo,
        'dimensao': dimensao,
        'cor': cor.valor,
        'material': material.valor,
        'formato': formato,
        'preco': preco,
      };
}
