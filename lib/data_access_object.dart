import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'models/motorista.dart';

class DataAccessObject {
  static Future<void> criarTabelas(sql.Database database) async {
    await database.execute("""
      CREATE TABLE motoristas (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nome TEXT NOT NULL,
        telefone TEXT NOT NULL,
        categoriaCnh TEXT NOT NULL,
        validadeCnh TEXT NOT NULL,
        observacao TEXT NOT NULL,
        createdAt TEXT NOT NULL
      );
    """);
  }

  static Future<sql.Database> abrirBanco() async {
    final databasesPath = await sql.getDatabasesPath();
    final path = join(databasesPath, 'motoristas.db');

    return sql.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await criarTabelas(db);
      },
    );
  }

  static Future<int> incluirMotorista(Motorista motorista) async {
    final banco = await abrirBanco();
    final valores = {
      'nome': motorista.nome,
      'telefone': motorista.telefone,
      'categoriaCnh': motorista.categoriaCnh,
      'validadeCnh': motorista.validadeCnh.toIso8601String(),
      'observacao': motorista.observacao,
      'createdAt': motorista.createdAt.toIso8601String(),
    };
    return banco.insert('motoristas', valores);
  }

  static Future<List<Motorista>> obterMotoristas() async {
    final banco = await abrirBanco();
    final maps = await banco.query('motoristas', orderBy: 'nome');
    return maps.map((map) => Motorista.deMap(map)).toList();
  }

  static Future<int> alterarMotorista(Motorista motorista) async {
    final banco = await abrirBanco();
    final valores = {
      'nome': motorista.nome,
      'telefone': motorista.telefone,
      'categoriaCnh': motorista.categoriaCnh,
      'validadeCnh': motorista.validadeCnh.toIso8601String(),
      'observacao': motorista.observacao,
      'createdAt': motorista.createdAt.toIso8601String(),
    };
    return banco.update(
      'motoristas',
      valores,
      where: 'id = ?',
      whereArgs: [motorista.id],
    );
  }

  static Future<bool> excluirMotorista(Motorista motorista) async {
    final banco = await abrirBanco();
    try {
      await banco.delete(
        'motoristas',
        where: 'id = ?',
        whereArgs: [motorista.id],
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
