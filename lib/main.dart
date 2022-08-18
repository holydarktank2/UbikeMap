import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'AttractionDB.dart';
import 'Attractions.dart';
import 'mapPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  List<Attractions> parseAttractions(String responseBody){
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Attractions>((json) => Attractions.fromJson(json)).toList();
  }
  Future<List<Attractions>> fetchAttractions(http.Client client) async {
    final response = await client
        .get(Uri.parse("https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json"));
    if (response.statusCode == 200) {
      await AttractionDB().insertAttractions(parseAttractions(response.body));
      return compute(parseAttractions, response.body);
    } else {
      throw Exception('Failed to load ');
    }
  }

  Future<void> loadDatabase() async{
    fetchAttractions(http.Client());
  }

  void updateDatabase() async{
    final response = await http.Client()
        .get(Uri.parse("https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json"));
    if (response.statusCode == 200) {
      await AttractionDB().updateAttractions(parseAttractions(response.body));
    } else {
      throw Exception('Failed to load ');
    }
  }



  @override
  Widget build(BuildContext context) {
    const appTitle = 'Ubike Map';
    loadDatabase();
    Timer.periodic(Duration(seconds: 30), (timer) {
      updateDatabase();
    });
    return MaterialApp(
        title: appTitle,
        theme: ThemeData(
        primarySwatch: Colors.purple,
    ),
    home: MapPage(),
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5F0A84),
      body: Center(
        child: Icon(
          Icons.directions_bike, size: MediaQuery.of(context).size.width * 0.7,
        ),
      ),
    );
  }
}

