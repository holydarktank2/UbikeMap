import 'dart:convert';

import 'main.dart';

class Attractions {
  final sno;//站點代號
  final sna;//場站中文名稱
  final bemp;//空位數量
  final sbi;//場站目前車輛數量
  final mday;//資料更新時間
  final ar;//地點
  final lat;//緯度
  final lng;//經度
  int saved = 0;

  Attractions({
    required this.sno,
    required this.sna,
    required this.bemp,
    required this.sbi,
    required this.mday,
    required this.ar,
    required this.lat,
    required this.lng,
    required this.saved,
  });

  factory Attractions.fromJson(Map<String, dynamic> json) {
    return Attractions(
      sno: json['sno'],
      sna: json['sna'],
      bemp: json['bemp'],
      sbi: json['sbi'],
      mday: json['mday'],
      ar: json['ar'],
      lat: json['lat'],
      lng: json['lng'],
      saved: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sno": sno,
      "sna": sna,
      "bemp": bemp,
      "sbi": sbi,
      "mday": mday,
      "ar": ar,
      "lat": lat,
      "lng": lng,
      "saved": saved,
    };
  }
}