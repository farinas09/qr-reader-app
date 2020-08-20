import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  int position=0;
  List<String> mapStyles = ['mapbox/streets-v11', 'mapbox/satellite-streets-v11', 'mapbox/satellite-v9', 'mapbox/outdoors-v11', 'mapbox/light-v10', 'mapbox/dark-v10'];

  MapController mapController = new MapController();
  @override
  Widget build(BuildContext context) {

    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación de QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: (){
              mapController.move(scan.getLatLng(), 15);
            },
          )
        ]
      ),
      body: _createMap(scan),
      floatingActionButton: _createFloatingActionButtom(context),
    );
  }

  Widget _createMap(ScanModel scan) {

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15
      ),
      layers: [
        _setUpMap(),
        _setUpMarkers(scan)
      ],
      );
  }

  _setUpMap() {

    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/'
        '{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
            'accessToken': 'pk.eyJ1IjoiZmFyaW5hczA5IiwiYSI6ImNrYjFqOTRuNjAxam8yb3BsMTdheGVxcGUifQ.viysBvqXani5pdk4nc3l-A',
            'id': mapStyles[position],
        },
    );

  }

  _setUpMarkers(ScanModel scan) {

    return MarkerLayerOptions(
      markers: <Marker> [
        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
            child: Icon(
              Icons.location_on, 
              size: 60.0,
              color: Theme.of(context).primaryColor
            ),
          )
        )
      ]
    );
  }

  Widget _createFloatingActionButtom(BuildContext context) {

    return FloatingActionButton(
      // 
      onPressed: (){
        if(position==mapStyles.length-1){
          position=0;
        } else {
        position = position+1;
        }
        setState(() {
          
        });
      },
      child: Icon(Icons.repeat, color: Colors.white),
      backgroundColor: Theme.of(context).primaryColor,

    );
  }
}