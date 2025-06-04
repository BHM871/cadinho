import 'package:cadinho/domain/lista.dart';

class Item {
  final int? id;
  final String titulo;
  final double? valor;
  final double quantidade;
  final ItemUnidade unidade;
  final double? promocional;
  final int? qtPromocao;
  final int idLista;
  Lista? lista;

  Item({
    this.id, 
    required this.titulo, 
    required this.valor, 
    required this.quantidade,
    required this.unidade,
    this.promocional,
    this.qtPromocao,
    required this.idLista,
    this.lista
  });

  double getValorTotal() {
    double out = 0;
    var val = valor ?? 1;
    var qtNormal = quantidade;

    if (promocional != null && qtPromocao != null) {
      var promocionalQuantidade = (quantidade / qtPromocao!).toInt();
      qtNormal = quantidade % qtPromocao!;

      out += promocional! * promocionalQuantidade;
    }
    
    out += qtNormal * val; 

    return out;
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?> {};

    if (id != null) {
      map['id'] = id;
    }

    map['titulo'] = titulo;

    if (valor != null) {
      map['valor'] = valor;
    }

    map['quantidade'] = quantidade;
    map['unidade'] = unidade.name;

    if (promocional != null) {
      map['promocional'] = promocional;
    }

    if (qtPromocao != null) {
      map['qt_promocao'] = qtPromocao;
    }

    map['id_lista'] = lista?.id ?? idLista;

    return map;
  }

  static Item fromMap(Map<String, Object?> map) {
    return Item(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      valor: map['valor'] as double,
      quantidade: map['quantidade'] as double,
      unidade: ItemUnidade.by(map['unidade'] as String),
      promocional: map['promocional'] as double?,
      qtPromocao: map['qt_promocao'] as int?,
      idLista: map['id_lista'] as int
    );
  }
}

enum ItemUnidade {
  kg,
  lt,
  un;

  static ItemUnidade by(String value) {
    if (value == ItemUnidade.kg.name) {
      return ItemUnidade.kg;
    }

    if (value == ItemUnidade.lt.name) {
      return ItemUnidade.lt;
    }

    if (value == ItemUnidade.un.name) {
      return ItemUnidade.un;
    }

    throw UnsupportedError("Valor não suportade");
  }
}
