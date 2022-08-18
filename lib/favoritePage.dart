import 'package:flutter/material.dart';
import 'package:ubikemap/webPage.dart';

import 'AttractionDB.dart';
import 'Attractions.dart';
import 'detailPage.dart';
import 'mapPage.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的最愛"),
        centerTitle: true,
        backgroundColor: Color(0xFAF860F0),
      ),
      body:WillPopScope(
        onWillPop: () async{
          final now = DateTime.now();
          final maxDuration = Duration(seconds: 2);
          final isWarning = lastPressed == null ||
              now.difference(lastPressed!) > maxDuration;

          if(isWarning){
            lastPressed = DateTime.now();
            final snackBar = SnackBar(
              content: Text("再按一次退出程式"),
              duration: maxDuration,
            );

            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(snackBar);
            return false;
          }
          else{
            return true;
          }},

        child: FutureBuilder(
          future: AttractionDB().showAll(),
          builder: (BuildContext context, AsyncSnapshot<List<Attractions>> snapshot) {
            if(snapshot.hasData) {
              return FavoriteList(attractions: snapshot.data!);
            }
            else {
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("123"),
              accountEmail: Text("456"),
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text("地圖"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MapPage()), (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("我的最愛"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => FavoritePage()), (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("網頁"),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WebPage()), (Route<dynamic> route) => false);
              },
            )
          ],
        ),
      ),
    );
  }
}


/*class AttractionsList extends StatelessWidget {
  const AttractionsList({Key? key, required this.attractions}) : super(key: key);

  final List<Attractions> attractions;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        itemCount: attractions.length,
        itemBuilder: (context, index) {
          if(attractions[index].saved == 1){
            return Card(
                child: ListTile(
                  key: ValueKey(attractions[index].sno),
                  title: Text(attractions[index].sna),
                  subtitle: Text("剩餘車輛: ${attractions[index].sbi.toString()}    空位數量: ${attractions[index].bemp.toString()}  "),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DetailPage(attractions: attractions[index]))
                    );
                  },
                ));
          }
          else{
            return Container();
          }
        },
        onReorder: (int oldIndex, int newIndex) {
        },
    );
  }
}*/

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key, required this.attractions}) : super(key: key);
  final List<Attractions> attractions;
  @override
  _FavoriteListState createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: widget.attractions.length,
      itemBuilder: (context, index) {
        if(widget.attractions[index].saved == 1){
          return Card(
              key: Key("${widget.attractions[index].sno}"),
              child: ListTile(
                title: Text(widget.attractions[index].sna),
                subtitle: Text("剩餘車輛: ${widget.attractions[index].sbi.toString()}    空位數量: ${widget.attractions[index].bemp.toString()}  "),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPage(attractions: widget.attractions[index]))
                  );
                },
              ));
        }
        else{
          return Container(
            key: Key("${widget.attractions[index].sno}"),
          );
        }
      },
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex = newIndex - 1;
          }
          final element = widget.attractions.removeAt(oldIndex);
          widget.attractions.insert(newIndex, element);
        });
      });
  }
}
