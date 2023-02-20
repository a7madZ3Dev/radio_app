// ignore_for_file: avoid_print

import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

import '../models/radio.dart';

abstract class DB {
  static sql.Database? _db;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      final databasesPath = await sql.getDatabasesPath();
      String _path = path.join(databasesPath, 'RadioApp.db');
      _db = await sql.openDatabase(_path, version: 1, onCreate: onCreate);
    } catch (ex) {
      print('Error happened when open database or create it');
    }
  }

  static void onCreate(sql.Database db, int version) async {
    await db.execute(
        'CREATE TABLE IF NOT EXISTS radios (id INTEGER PRIMARY KEY, radioName TEXT, radioURL TEXT, radioDesc TEXT, radioWebsite TEXT, radioPic TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS radios_bookmarks (id INTEGER PRIMARY KEY, isFavorite INTEGER)');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db!.query(table);

  static Future<int> insert(String table, DBBaseModel model) async =>
      await _db!.insert(
        table,
        model.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );

  static Future<List<Map<String, dynamic>>> rawQuery(String sql) async =>
      _db!.rawQuery(sql);

  static Future<int> rawInsert(String sql) async => await _db!.rawInsert(sql);
}
