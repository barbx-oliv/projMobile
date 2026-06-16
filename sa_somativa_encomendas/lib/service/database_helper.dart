import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_somativa_encomendas/model/morador_model.dart';
import 'package:sa_somativa_encomendas/model/encomenda_model.dart';

class DatabaseHelper {
  // Singleton - apenas um objeto por vez
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), "entregas_db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE moradores(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            documento TEXT,
            idade INTEGER,
            endereco TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE encomendas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            moradorId INTEGER,
            tipoEncomenda TEXT,
            dataEntrega TEXT,
            dataSaida TEXT,
            observacoes TEXT,
            FOREIGN KEY(moradorId) REFERENCES moradores(id) ON DELETE CASCADE
          )
        ''');
      },
      onConfigure: (db) async =>
          await db.execute("PRAGMA foreign_keys = ON"),
    );
  }

  // Inserir morador - POST
  Future<int> insertMorador(Morador morador) async =>
      (await database).insert("moradores", morador.toMap());

  // Listar todos moradores - GET
  Future<List<Morador>> getMoradores() async {
    final List<Map<String, dynamic>> maps =
        await (await database).query("moradores", orderBy: "nome ASC");
    return List.generate(maps.length, (i) => Morador.fromMap(maps[i]));
  }

  // Inserir encomenda - POST
  Future<int> insertEncomenda(Encomenda e) async =>
      (await database).insert("encomendas", e.toMap());

  // Buscar encomendas por morador - GET
  Future<List<Encomenda>> getEncomendaPorMorador(int moradorId) async {
    final List<Map<String, dynamic>> maps = await (await database).query(
      "encomendas",
      where: "moradorId = ?",
      whereArgs: [moradorId],
      orderBy: "dataEntrega DESC",
    );
    return List.generate(maps.length, (i) => Encomenda.fromMap(maps[i]));
  }
}