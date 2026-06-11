import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/motorista.dart';

class ServicoBaseDados {
  static const String _databaseName = 'drivers_database.db';
  static const String _tableName = 'drivers';
  static const int _databaseVersion = 1;

  static final ServicoBaseDados _instance = ServicoBaseDados._internal();

  factory ServicoBaseDados() {
    return _instance;
  }

  ServicoBaseDados._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cpf TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        email TEXT NOT NULL,
        licenseNumber TEXT NOT NULL UNIQUE,
        licenseCategory TEXT NOT NULL,
        licenseExpiryDate TEXT NOT NULL,
        instructions TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
  }

  // Inserir novo motorista
  Future<int> adicionarMotorista(Motorista motorista) async {
    final db = await database;
    return await db.insert(
      _tableName,
      motorista.paraMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obter todos os motoristas
  Future<List<Motorista>> obterTodosMotoristas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Motorista.deMap(maps[i]);
    });
  }

  // Obter motorista por ID
  Future<Motorista?> obterMotoristaID(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Motorista.deMap(maps.first);
    }
    return null;
  }

  // Atualizar motorista
  Future<int> atualizarMotorista(Motorista motorista) async {
    final db = await database;
    return await db.update(
      _tableName,
      motorista.paraMap(),
      where: 'id = ?',
      whereArgs: [motorista.id],
    );
  }

  // Deletar motorista
  Future<int> deletarMotorista(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fechar banco de dados
  Future<void> fecharBaseDados() async {
    final db = await database;
    await db.close();
  }
}
