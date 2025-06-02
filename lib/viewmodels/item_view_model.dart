import 'package:cadinho/config/database_config.dart';
import 'package:cadinho/domain/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemViewModel {

  const ItemViewModel();

  Future<Item?> buscarId(int id) async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap;
    try {
      listMap = await bd.query(
        'Item', 
        where: 'id = ?', whereArgs: [id], 
        limit: 1
      );
    } catch (e) {
      return null;
    }

    if (listMap.isEmpty) return null;

    return Item.fromMap(listMap[0]);
  }

  Future<List<Item>?> buscarTodos(int idLista) async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap;
    List<Item> items = [];
    try {
      listMap = await bd.query(
        'Item',
        where: 'id_lista = ?', whereArgs: [idLista]
      );
    } catch (e) {
      return null;
    }

    if (listMap.isEmpty) return null;

    for(Map<String, Object?> obj in listMap) {
      items.add(Item.fromMap(obj));
    }

    return items;
  }
  
  Future<Item?> salvar(Item item) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = item.toMap();

        await trs.insert('Item', map);
        map = (await trs.query(
          'Item', 
          orderBy: 'id DESC', limit: 1
        ))[0];

        item = Item.fromMap(map);
      });
    } catch (e) {
      return null;
    }

    return item;
  }

  Future<Item?> atualizar(Item item) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = item.toMap();

        await trs.update(
          'Item', map, 
          where: 'id = ?', whereArgs: [map['id']]
        );
        map = (await trs.query(
          'Item', 
          where: 'id = ?', whereArgs: [map['id']]
        ))[0];

        item = Item.fromMap(map);
      });
    } catch (e) {
      return null;
    }

    return item;
  }

  Future<bool> excluir(Item item) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = item.toMap();

        await trs.delete(
          'Item', 
          where: 'id = ?', whereArgs: [map['id']]
        );
      });
    } catch (e) {
      return false;
    }

    return true;
  }
}
