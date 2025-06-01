import 'package:cadinho/domain/lista.dart';

class Item {
  final int? id;
  final String titulo;
  final double valor;
  final int quantidade;
  final double? promocional;
  final int? qtPromocao;
  final int idLista;
  Lista? lista;

  Item({
    this.id, 
    required this.titulo, 
    required this.valor, 
    required this.quantidade,
    this.promocional,
    this.qtPromocao,
    required this.idLista,
    this.lista
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?> {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'quantidade': quantidade,
      'promocional': promocional,
      'qt_promocao': qtPromocao,
      'id_lista': lista?.id ?? idLista
    };
    return map;
  }

  static Item fromMap(Map<String, Object?> map) {
    return Item(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      valor: map['valor'] as double,
      quantidade: map['quantidade'] as int,
      promocional: map['promocional'] as double?,
      qtPromocao: map['qt_pPromocao'] as int?,
      idLista: map['id_lista'] as int,
      lista: Lista(id: map['id_lista'] as int)
    );
  }
}
