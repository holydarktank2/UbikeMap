import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'favoritePage.dart';
import 'mapPage.dart';

class WebPage extends StatelessWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFAF860F0),
      ),
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
      body: WebView(
        initialUrl: "https://www.google.com/",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
