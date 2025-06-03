import 'package:cadinho/config/database_config.dart';
import 'package:cadinho/domain/lista.dart';
import 'package:sqflite/sqflite.dart';

class ListaRepository {

  const ListaRepository();

  Future<Lista?> buscarId(int id) async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap = await bd.query(
      'Lista', 
      where: 'id = ?', whereArgs: [id], 
      limit: 1
    );

    if (listMap.isEmpty) return null;

    return Lista.fromMap(listMap[0]);
  }

  Future<List<Lista>?> buscarTodas() async {
    Database bd = await DatabaseConfig.get();

    List<Map<String, Object?>>? listMap = await bd.query('Lista');
    List<Lista> listas = [];

    if (listMap.isEmpty) return null;

    for(Map<String, Object?> obj in listMap) {
      listas.add(Lista.fromMap(obj));
    }

    return listas;
  }
  
  Future<Lista?> salvar(Lista lista) async {
    Database db = await DatabaseConfig.get();

    await db.transaction((trs) async { 
      var map = lista.toMap();

      await trs.insert('Lista', map);
      map = (await trs.query(
        'Lista', 
        orderBy: 'id DESC', limit: 1
      ))[0];

      lista = Lista.fromMap(map);
    });

    return lista;
  }

  Future<Lista?> atualizar(Lista lista) async {
    Database db = await DatabaseConfig.get();

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

    return lista;
  }

  Future<void> excluir(Lista lista) async {
    Database db = await DatabaseConfig.get();

    await db.transaction((trs) async { 
      var map = lista.toMap();

      await trs.delete(
        'Lista', 
        where: 'id = ?', whereArgs: [map['id']]
      );
    });
  }
}
