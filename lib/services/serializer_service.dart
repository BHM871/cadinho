import 'dart:convert';

import '../domain/item.dart';
import '../domain/lista.dart';

class SerializerService {

  const SerializerService();

  String encode(Lista lista) {
    String out = _encodeLista(lista);

    return base64Encode(utf8.encode(out));
  }

  Lista? decode(String encoded) {
    if (encoded.trim().isEmpty) return null;

    encoded = utf8.decode(base64Decode(encoded));

    return _decodeLista(encoded);
  }

  String _encodeLista(Lista lista) {
    String encodedItens = '';
    for (int i = 0; i < lista.itens.length; i++) {
      if (i > 0) encodedItens += ',';
      encodedItens += _encodeItem(lista.itens[i]);
    }

    String out = 'Lista{id:int=${lista.id!}';
    out += ';titulo:String=${lista.titulo}';

    if (lista.mercado != null) {
      out += ';mercado:String=${lista.mercado!}';
    }
    if (lista.data != null) {
      out += ';data:DateTime=${lista.data!}';
    }

    out += ';status:String=${lista.status.value}';
    out += ';total:double=${lista.total}';

    if (lista.itens.isNotEmpty) {
      out += ';itens:List<Item>=[$encodedItens]';
    }

    out += '}';

    return out;
  }

  String _encodeItem(Item item) {
    String out = 'Item{id:int=${item.id!}';
    out += ';titulo:String=${item.titulo}';
    out += ';quantidade:double=${item.quantidade}';
    out += ';unidade:ItemUnidade=${item.unidade.name}';

    if (item.valor != null) {
      out += ';valor:double=${item.valor}';
    }
    if (item.promocional != null) {
      out += ';promocional:double=${item.promocional}';
    }
    if (item.qtPromocao != null) {
      out += ';qt_promocao:int=${item.qtPromocao}';
    }

    out += ';id_lista:int=${item.idLista}';

    out += '}';

    return out;
  }

  Lista? _decodeLista(String encoded) {
    if (encoded.trim().isEmpty) return null;

    var tmp = encoded.substring(0, 5);
    if (tmp != 'Lista') return null;
    encoded = encoded.substring(6, encoded.length-1);

    var map = <String, Object?>{};
    for (int i = 0; i < encoded.length; i++) {
      String attributeDivider = ';';

      String attribute = _getParam(encoded, i, ':'); i += attribute.length + 1;
      String type = _getParam(encoded, i, '='); i += type.length + 1;

      if (attribute == 'itens') {
        attributeDivider = ']';
      }

      String value = _getParam(encoded, i, attributeDivider); i += value.length;

      map[attribute] = convertValue(type, value);
      if (map[attribute] == null) return null;
    }

    var lista = Lista.fromMap(map);

    if (map.containsKey('itens')) {
      lista.itens = map['itens'] as List<Item>;
    }

    return lista;
  }

  List<Item>? _decodeItens(String encoded) {
    List<Item> itens = [];

    encoded = encoded.substring(1);

    for(String en in encoded.split(',')) {
      Item? item = _decodeItem(en);

      if (item == null) return null;

      itens.add(item);
    }

    return itens;
  }

  Item? _decodeItem(String encoded) {
    var tmp = encoded.substring(0, 4);
    if (tmp != "Item") return null;

    encoded = encoded.substring(5, encoded.length-1);

    var map = <String, Object?>{};

    for (int i = 0; i < encoded.length; i++) {
      String attribute = _getParam(encoded, i, ':'); i += attribute.length + 1;
      String type = _getParam(encoded, i, '='); i += type.length + 1;
      String value = _getParam(encoded, i, ';'); i += value.length;

      map[attribute] = convertValue(type, value);
      if (map[attribute] == null) return null;
    }

    return Item.fromMap(map);
  }

  String _getParam(String encoded, int start, String divider) {
    String param = '';

    for (int i = start; i < encoded.length; i++) {
      if (encoded[i] == divider) break;

      param += encoded[i];
    }

    return param;
  }

  Object? convertValue(String type, String value) {
    switch(type) {
      case 'String': return value;
      case 'int':
        return int.tryParse(value);
      case 'double':
        return double.tryParse(value);
      case 'DateTime' :
        return value;
      case 'ListaStatus':
        return value;
      case 'ItemUnidade':
        return value;
      case 'List<Item>':
        return _decodeItens(value);
      default: return null;
    }
  }
}