import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qrreaderapp/src/models/scan_model.dart';
//export this package to other files that imports db_provider
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    
    //database exist
    if (_database != null) return _database;

    //database is null
    _database = await initDB();
    return _database;
  }

  initDB() async {
    
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //db extension for sqflite
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scan ('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT)'
          );
      }
    );
  }

  // Crear Registro
  createScan(ScanModel newScan) async {
    final db = await  database;
    
    final res = await db.rawInsert(
      "INSERT INTO Scan (id, tipo, valor) "
      "VALUES (${newScan.id}, '${newScan.tipo}', '${newScan.valor})'"
    );

    return res;
  }

  Future<int> insertScan(ScanModel model) async {
    final db = await  database;
    
    final int res = await db.insert('Scan', model.toJson());

    return res;
  }

  //Select
  Future<ScanModel> getScanById(int id) async {
    final db = await database;

    final res = await db.query('Scan', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;

    final res = await db.query('Scan');

    List<ScanModel> list = res.isNotEmpty ? res.map((item) => ScanModel.fromJson(item)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await database;

    final res = await db.query('Scan', where: 'tipo = ?', whereArgs: [type]);

    List<ScanModel> list = res.isNotEmpty 
      ? res.map((item) => ScanModel.fromJson(item)).toString() 
      : [];
      
    return list;
  }

  //Update

  Future<int>updateScan(ScanModel model) async {
    final db = await database;
    final res = await db.update('Scan', model.toJson(), where: 'id = ?', whereArgs: [model.id]);
    return res;
  }

  Future<int> deleteScan(int id) async{
    final db = await database;
    return await db.delete('Scan', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllScans() async{
    final db = await database;
    return await db.delete('Scan');
  }
}