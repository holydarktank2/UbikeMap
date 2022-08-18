import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ubikemap/webPage.dart';

import 'AttractionDB.dart';
import 'Attractions.dart';
import 'detailPage.dart';
import 'favoritePage.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  final Completer<GoogleMapController> _mapController = Completer();
  int flex1 = 10;
  int flex2 = 1;
  DateTime? lastPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("地圖"),
        centerTitle: true,
        backgroundColor: Color(0xFAF860F0),
      ),
      body:
      WillPopScope(
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
            }

          },
          child: FutureBuilder<List<Attractions>>(
            future: AttractionDB().showAll(),
            builder: (context, snapshot){
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error has occurred!'),
                );
              }
              else if (snapshot.hasData) {
                return Column(
                  children: [
                    Flexible(
                      child: AttractionsMap(attractions:snapshot.data!, mapController: _mapController,),
                      flex: flex1,
                    ),
                    Flexible(
                      child: AttractionsList(attractions: snapshot.data!, mapcontroller: _mapController,),
                      flex: flex2,
                    )
                  ],
                );
              }
              else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            flex2 == 10? flex2 = 1: flex2 = 10;
          });
        },
        heroTag: null,
        backgroundColor: Color(0xFAE53EDD),
        child: Icon(
            flex2 == 10? Icons.keyboard_arrow_down_rounded: Icons.keyboard_arrow_up_rounded
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

class AttractionsMap extends StatefulWidget {
  const AttractionsMap({Key? key,required this.attractions, required this.mapController}) : super(key: key);
  final List<Attractions> attractions;
  final Completer<GoogleMapController> mapController;

  @override
  _AttractionsMapState createState() => _AttractionsMapState();
}

class _AttractionsMapState extends State<AttractionsMap> {
  Location location = new Location();
  late LocationData _currentPosition;
  late LatLng _currentCameraPosition;
  List<Attractions> attr = [];

  void toList() async{
    attr = await AttractionDB().showAll();
  }

  List<Marker> _markers () {
    List<Marker> ans = [];
    for(int i = 0; i < widget.attractions.length; i++){
      ans.add(
          Marker(
            markerId: MarkerId(widget.attractions[i].sno.toString()),
            position: LatLng(double.parse(widget.attractions[i].lat),double.parse(widget.attractions[i].lng)),
            infoWindow: InfoWindow(
                title: widget.attractions[i].sna,
                snippet: widget.attractions[i].ar,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPage(attractions: widget.attractions[i])))
                      .then((value) => setState(() {}));
                }
            ),
            icon: widget.attractions[i].saved == 1? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet):BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          )
      );
    }
    return ans;
  }
/*  List<Marker> _markers () {
    List<Marker> ans = [];
    for(int i = 0; i < attr.length; i++){
      ans.add(
          Marker(
            markerId: MarkerId(attr[i].sno.toString()),
            position: LatLng(double.parse(attr[i].lat),double.parse(widget.attractions[i].lng)),
            infoWindow: InfoWindow(
                title: attr[i].sna,
                snippet: attr[i].ar,
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DetailPage(attractions: attr[i])))
                      .then((value) => setState(() { toList(); }));
                }
            ),
            icon: attr[i].saved == 1? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet):BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          )
      );
    }
    return ans;
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
    toList();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _currentCameraPosition,
            zoom: 16.0,
          ),
          onMapCreated: (mapController){
            this.widget.mapController.complete(mapController);
          },
          markers: _markers().toSet(),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
        ),
        floatingActionButton: Container(
          height: 40.0,
          width: 40.0,
          child: FittedBox(
            child:  FloatingActionButton(
              onPressed: () async {
                getLoc();
                final controller = await widget.mapController.future;
                await controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _currentCameraPosition,
                        zoom: 16.0,
                      )
                  ),
                );
              },
              heroTag: null,
              child: const Icon(
                Icons.assistant_navigation,
                size: 56,
                color: Color(0xFAE53EDD),
              ),
              backgroundColor: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      );
  }
  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentPosition = await location.getLocation();
    _currentCameraPosition = LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
    location.onLocationChanged.listen((currentLocation) {
      _currentPosition = currentLocation;
      _currentCameraPosition = LatLng(_currentPosition.latitude!, _currentPosition.longitude!);
      if(mounted)
        setState(() {
        });
    });
  }
}

class AttractionsList extends StatefulWidget {
  const AttractionsList({Key? key,required this.attractions, required this.mapcontroller}) : super(key: key);
  final List<Attractions> attractions;
  final Completer<GoogleMapController> mapcontroller;

  @override
  _AttractionsListState createState() => _AttractionsListState();
}

class _AttractionsListState extends State<AttractionsList> {

  @override
  Widget build(BuildContext context) {
    /*int j = 0;
    for(int i=0; i<widget.attractions.length; i++){
      if(widget.attractions[i].saved == 1) {
        var temp = widget.attractions[i];
        widget.attractions[i] = widget.attractions[j];
        widget.attractions[j] = temp;
        j++;
      }
    }*/
    for(int i=0; i<widget.attractions.length; i++) {
      if(widget.attractions[i].saved == 1) {
        int j = i;
        var temp = widget.attractions[j];
        while(j > 0) {
          widget.attractions[j] = widget.attractions[j-1];
          j--;
        }
        widget.attractions[0] = temp;
      }
    }
    return ListView.builder(
      itemCount: widget.attractions.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
                title: Text("名稱: ${widget.attractions[index].sna.toString()}"),
                subtitle: Text("空位數量: ${widget.attractions[index].bemp.toString()}  剩餘車輛: ${widget.attractions[index].sbi.toString()}"),
                trailing: IconButton(
                  onPressed: () async{
                    var change;
                    if(widget.attractions[index].saved == 1)
                      change = 0;
                    else
                      change = 1;
                    await AttractionDB().savedtoFavorite(
                        widget.attractions[index].sno,change
                    );
                    setState(() {
                      widget.attractions[index].saved = change;
                    });
                  },
                  icon: Icon(
                      widget.attractions[index].saved == 1? Icons.favorite: Icons.favorite_border),
                  color: widget.attractions[index].saved == 1? Colors.red: null,
                ),
                onTap: () async {
                  final controller = await widget.mapcontroller.future;
                  await controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                              double.parse(widget.attractions[index].lat),
                              double.parse(widget.attractions[index].lng)
                          ),
                          zoom: 20.0,
                        ),
                      )
                  );
                }
            )
        );
      },
    );
  }
}

