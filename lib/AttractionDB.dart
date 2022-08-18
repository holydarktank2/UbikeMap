import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Attractions.dart';

class AttractionDB {

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), "Attraction_database.db"),
      onCreate: (db, version) async{
        await db.execute(
            "CREATE TABLE Attractions("
                "sno TEXT PRIMARY KEY,"
                "sna TEXT,"
                "bemp INTEGER,"
                "sbi INTEGER,"
                "mday TEXT,"
                "ar TEXT,"
                "lat TEXT,"
                "lng TEXT,"
                "saved NUMERIC"
                ")"
        );
      },
      version: 1,
    );
  }

  Future<List<Attractions>> showAll() async{
    final Database db = await initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('Attractions');

    return List.generate(maps.length, (i) {
      return Attractions(
        sno: maps[i]["sno"],//代號
        sna: maps[i]["sna"],//名稱
        bemp: maps[i]["bemp"],//空位數量
        sbi: maps[i]["sbi"],//目前數量
        mday: maps[i]["mday"],//更新時間
        ar: maps[i]["ar"],//地點
        lat: maps[i]["lat"],//緯度
        lng: maps[i]["lng"],//經度
        saved: maps[i]["saved"],
      );
    });
  }

  Future<void> insertAttractions(List<Attractions> attractions) async {
    final Database db = await initDatabase();
    for(var attractions in attractions) {
      await db.insert(
        "Attractions",
        attractions.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> savedtoFavorite(var sno, int saved) async{
    final Database db = await initDatabase();
    await db.rawUpdate(
        "UPDATE Attractions "
            "SET saved = ?"
            "WHERE sno = ?",
        [saved, sno]);
  }

  Future<void> updateAttractions(List<Attractions> attractions) async{
    final Database db = await initDatabase();
    for(var attractions in attractions) {
      await db.rawUpdate(
          "UPDATE Attractions "
              "SET bemp = ?, sbi = ?, mday = ?"
              "WHERE sno = ?",
          [attractions.bemp, attractions.sbi, attractions.mday, attractions.sno]);
    }
  }

/*  Future<Attractions> queryAttraction(var sno) async{
    final Database db = await initDatabase();
    Map<String, dynamic> maps =
    return null;
  }*/

}