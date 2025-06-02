import 'package:cadinho/config/database_config.dart';
import 'package:cadinho/domain/lista.dart';
import 'package:sqflite/sqflite.dart';

class ListaViewModel {

  Future<Lista?> buscarId(int id) async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap;
    try {
      listMap = await bd.query(
        'Lista', 
        where: 'id = ?', whereArgs: [id], 
        limit: 1
      );
    } catch (e) {
      return null;
    }

    if (listMap.isEmpty) return null;

    return Lista.fromMap(listMap[0]);
  }

  Future<List<Lista>?> buscarTodas() async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap;
    List<Lista> listas = [];
    try {
      listMap = await bd.query('Lista');
    } catch (e) {
      return null;
    }

    if (listMap.isEmpty) return null;

    for(Map<String, Object?> obj in listMap) {
      listas.add(Lista.fromMap(obj));
    }

    return listas;
  }
  
  Future<Lista?> salvar(Lista lista) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = lista.toMap();

        await trs.insert('Lista', map);
        map = (await trs.query(
          'Lista', 
          orderBy: 'id DESC', limit: 1
        ))[0];

        lista = Lista.fromMap(map);
      });
    } catch (e) {
      return null;
    }

    return lista;
  }

  Future<Lista?> atualizar(Lista lista) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = lista.toMap();

        await trs.update(
          'Lista', map, 
          where: 'id = ?', whereArgs: [map['id']]
        );
        map = (await trs.query(
          'Lista', 
          where: 'id = ?', whereArgs: [map['id']]
        ))[0];

        lista = Lista.fromMap(map);
      });
    } catch (e) {
      return null;
    }

    return lista;
  }

  Future<bool> excluir(Lista lista) async {
    Database db = await DatabaseConfig.get();

    try {
      await db.transaction((trs) async { 
        var map = lista.toMap();

        await trs.delete(
          'Lista', 
          where: 'id = ?', whereArgs: [map['id']]
        );
      });
    } catch (e) {
      return false;
    }

    return true;
  }
}
