import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConfig {
  
  static Database? _db;
  static bool _isSetupped = false;
  static String _path = "";
  static final String _dbname = "cadinho.db";

  static Future<void> setup() async {
  if (_isSetupped) return;

    String dbPath = await getDatabasesPath();
    _path = join(dbPath, _dbname);
    
    try {
      await Directory(dirname(_path)).create(recursive: true);
    } catch (_) {}
    
    _isSetupped = true;
  }

  static Future<Database> get() async {
    if (_db != null) return _db!;
  
    await setup();

    _db = await openDatabase(
      _path,
      version: 1, 
      singleInstance: true,
      onConfigure: _onConfigure,
      onCreate: _onCreate
    );

    return _db!;
  }

  static close() {
    _db?.close();
  }

  static _onConfigure(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
  }

  static _onCreate(Database db, int version) async {
    await db.execute("""CREATE TABLE Lista (
      id        INTEGER     PRIMARY KEY, 
      titulo    TEXT        CHECK(LENGTH(titulo) <= 100)                            NOT NULL UNIQUE,
      mercado   TEXT        CHECK(LENGTH(mercado) <= 100)                           NOT NULL DEFAULT 'Não informado',
      data      TEXT,
      status    TEXT        CHECK(status IN('PENDENTE', 'EM CURSO', 'FINALIZADO'))  NOT NULL DEFAULT 'PENDENTE',
      total     REAL        CHECK(total >= 0)                                       NOT NULL DEFAULT 0
    )""");
   
    await db.execute("""CREATE TABLE Item (
      id            INTEGER PRIMARY KEY,
      titulo        TEXT    CHECK(LENGTH(titulo) <= 100)                    NOT NULL,
      valor         REAL    CHECK(valor > 0 AND valor <= 10000)               DEFAULT 1,
      quantidade    REAL    CHECK(quantidade > 0)                           NOT NULL DEFAULT 1,
      unidade       TEXT    CHECK(unidade IN('kg', 'lt', 'un'))             NOT NULL DEFAULT 'kg',
      promocional   REAL    CHECK(promocional > 0 AND promocional <= 10000),
      qt_promocao   INTEGER CHECK(qt_promocao > 1),
      id_lista      INTEGER CHECK(id_lista > 0)                             NOT NULL,
      FOREIGN KEY(id_lista) REFERENCES Lista(id) ON DELETE CASCADE
    )""");
  }
}
