import 'dart:async';

import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //obtains database scans
    obtainScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();
  
  Stream<List<ScanModel>> get scanStream => _scansController.stream.transform(validateGeo);
  Stream<List<ScanModel>> get scanStreamHttp => _scansController.stream.transform(validateHttp);
  
  
  dispose() {
    _scansController?.close();
  }

  obtainScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  addScan(ScanModel model) async {
    int res = await DBProvider.db.insertScan(model);
    obtainScans();
    return res;
  }

  removeScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtainScans();
  }

  removeAllScans() async {
    await DBProvider.db.deleteAllScans();
    obtainScans();
  }

}