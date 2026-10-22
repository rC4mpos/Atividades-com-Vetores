// Espelho da entidade CaixaDAgua do backend (model/CaixaDAgua.kt)

// Os nomes dos enums ficam iguais aos do Kotlin, porque é assim que vêm no JSON
// ignore_for_file: constant_identifier_names

enum Cor {
  AZUL_FORTE('Azul forte'),
  AZUL_FRACO('Azul fraco'),
  BRANCO('Branco'),
  CINZA('Cinza');

  final String descricao;
  const Cor(this.descricao);
}

// No Kotlin o enum se chama Material, mas no Flutter esse nome já é usado
// pelo widget Material, por isso aqui ele se chama MaterialCaixa
enum MaterialCaixa {
  POLIETILENO('Polietileno'),
  FIBRA_DE_VIDRO('Fibra de vidro'),
  INOX('Inox');

  final String descricao;
  const MaterialCaixa(this.descricao);
}

class CaixaDAgua {
  final int? id;
  final String marca;
  final String modelo;

  // Dimensão (altura, largura, profundidade)
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

  // JSON que vem do backend -> objeto Dart
  factory CaixaDAgua.fromJson(Map<String, dynamic> json) {
    return CaixaDAgua(
      id: json['id'] as int?,
      marca: json['marca'] as String,
      modelo: json['modelo'] as String,
      dimensao: (json['dimensao'] as List<dynamic>? ?? [])
          .map((valor) => (valor as num).toDouble())
          .toList(),
      cor: Cor.values.byName(json['cor'] as String),
      material: MaterialCaixa.values.byName(json['material'] as String),
      formato: json['formato'] as String,
      preco: (json['preco'] as num).toDouble(),
    );
  }

  // Objeto Dart -> JSON enviado para o backend
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'marca': marca,
      'modelo': modelo,
      'dimensao': dimensao,
      'cor': cor.name,
      'material': material.name,
      'formato': formato,
      'preco': preco,
    };
  }
}
