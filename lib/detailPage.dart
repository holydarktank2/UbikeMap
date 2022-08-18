import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'AttractionDB.dart';
import 'Attractions.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.attractions}) : super(key: key);
  final Attractions attractions;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.airline_seat_flat_angled),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text(widget.attractions.sna.toString()),
        backgroundColor: Color(0xFAF860F0),
        actions: <Widget>[
          IconButton(
              onPressed: () async{
                var change;
                if(widget.attractions.saved == 1)
                  change = 0;
                else
                  change = 1;
                await AttractionDB().savedtoFavorite(
                    widget.attractions.sno,change
                );
                setState(() {
                  widget.attractions.saved = change;
                });
              },
              icon: Icon(
                widget.attractions.saved == 1? Icons.favorite: Icons.favorite_border,
                color: widget.attractions.saved == 1? Colors.red: null,)
          )
        ],
        centerTitle: true,
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image.asset("assets/images/bike.jpg"),
            flex: 1
          ),
          Container(
            color: Color(0xFFD5296E),
            height: 5,
          ),
          ListTile(
            title: Text("站名: ${widget.attractions.sna.toString()}", style: TextStyle(),),
          ),
          ListTile(
            title: Text("地點: ${widget.attractions.ar.toString()}"),
          ),
          ListTile(
            title: Text("剩餘車輛: ${widget.attractions.sbi.toString()}    空位數量: ${widget.attractions.bemp.toString()}"),
          ),
          ListTile(
            title: Text("更新時間: ${widget.attractions.mday.toString()}"),
          ),
          Expanded(
            child: Container(
              color: Color(0xFFD4D4),
            ),
            flex: 1,
          )
        ],
      )
    );
  }
}
