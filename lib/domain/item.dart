class Item {
  final int? id;
  final String titulo;
  final double valor;
  final int quantidade;
  final double? promocional;
  final int? qtPromocao;
  final int idLista;

  Item({
    this.id, 
    required this.titulo, 
    required this.valor, 
    required this.quantidade,
    this.promocional,
    this.qtPromocao,
    required this.idLista
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?> {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'quantidade': quantidade,
      'promocional': promocional,
      'qt_promocao': qtPromocao,
      'id_lista': idLista
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
    );
  }
}
