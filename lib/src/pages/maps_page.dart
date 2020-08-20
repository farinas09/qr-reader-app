import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/url_utils.dart';

class MapsPage extends StatelessWidget {

  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtainScans();

    return StreamBuilder<List<ScanModel>>(
        stream: scansBloc.scanStream,
        builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
          
          if(!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data;

          if(items.length==0) {
            return Center(child: Text('No hay datos'));
          }

          return _createListView(items);
        },
      );
  }

  Widget _createListView(List<ScanModel> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => Dismissible(
        key: UniqueKey(),
        background: _positiveBackground(),
        secondaryBackground: _deleteBackground(),
        child: ListTile(
          leading: Icon(Icons.directions, color: Theme.of(context).primaryColor),
          title: Text(items[i].valor),
          trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey,),
          subtitle: Text(items[i].id.toString()),
          onTap: () {
            launchURL(context, items[i]);
          },
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            scansBloc.removeScan(items[i].id);
          }
          if (direction == DismissDirection.startToEnd) {

          }
        },
      )
    );
  }

  _positiveBackground() {
    return Container(
      color: Colors.green,
      child: Row(
        children: [
          SizedBox(width: 20),
          Icon(CupertinoIcons.heart_solid, color: Colors.white),
          Text('Visitar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ]),
  );
  }

  _deleteBackground() {
    return Container(
      color: Colors.red[700],
      child: Row(
        children: [
          Expanded(child: Container()),
          Text('Eliminar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          Icon(Icons.delete_outline, color: Colors.white),
          SizedBox(width: 20)
        ]
      ),
    );
  }
}