import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';

import 'package:qrreaderapp/src/pages/directions_page.dart';
import 'package:qrreaderapp/src/pages/maps_page.dart';
import 'package:qrreaderapp/src/utils/url_utils.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final scansBloc = new ScansBloc();


  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: scansBloc.removeAllScans,
          )
        ]
      ),
      body: _loadPage(currentPage),
      bottomNavigationBar: _createBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.filter_center_focus, color: Colors.white),
        onPressed: () => _scanQR(context)
        ),
    );
  }

  Widget _createBottomNavigationBar() {

    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: (index) {
        setState(() {
          currentPage = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on),
          title: Text('Locations')),
        BottomNavigationBarItem(
          icon: Icon(Icons.folder),
          title: Text('Direcciones')),
      ],
      );
  }

  Widget _loadPage(int page) {

    switch (page) {
      case 0: return MapsPage();
      case 1: return DirectionsPage();
      default: return MapsPage();
    }
  }

  _scanQR(BuildContext context) async {

    dynamic futureString;
 
    try {
      futureString = await BarcodeScanner.scan();
    }catch(e){
      futureString=e.toString();
    }
    
    if(futureString != null) {
      final model = ScanModel(valor: futureString.rawContent);
      
      int save = await scansBloc.addScan(model);
      if (save != 0) {
        Fluttertoast.showToast(
        msg: "Guardado correctamente",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white
        );
        
        if(Platform.isIOS) {
          Future.delayed(Duration(milliseconds: 750), () {
            launchURL(context, model);
          });
        } else {
          launchURL(context, model);
        }
        
      }
    }
  }


}