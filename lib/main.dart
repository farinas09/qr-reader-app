import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/pages/home_page.dart';
import 'package:qrreaderapp/src/pages/map_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext context) => HomePage(),
        'directions' : (BuildContext context) => DirectionsPage(),
        'maps' : (BuildContext context) => MapsPage(),
        'map' : (BuildContext context) => MapPage()
      },
      theme: ThemeData(
        primaryColor: Colors.lightGreen[700],
        accentColor: Colors.lightGreen[400],
      )
    );
  }
}