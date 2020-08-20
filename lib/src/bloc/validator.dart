

import 'dart:async';

import 'package:qrreaderapp/src/models/scan_model.dart';

class Validators {

  final validateGeo = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {

      final geoScans = data.where((scan) => scan.tipo == 'geo').toList();

      sink.add(geoScans);
    }
  );

  final validateHttp = StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {

      final httpScans = data.where((scan) => scan.tipo == 'http').toList();

      sink.add(httpScans);
    }
  );
}