import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sensors/sensors.dart';

class HomeViewModel extends BaseViewModel {
  StreamSubscription<UserAccelerometerEvent> _subscriptionAcc;
  StreamSubscription<GyroscopeEvent> _subscriptionGyro;
  GlobalKey<ScaffoldState> _scaffoldKey;
  List<FlSpot> _spotsListAccX;
  List<FlSpot> _spotsListAccY;
  List<FlSpot> _spotsListAccZ;
  List<FlSpot> get spotsListAccX => _spotsListAccX;
  List<FlSpot> get spotsListAccZ => _spotsListAccZ;
  List<FlSpot> get spotsListAccY => _spotsListAccY;
  double _counter = 0.0;

  set spotsListAccX(value) {
    _spotsListAccX = value;
    notifyListeners();
  }

  set spotsListAccY(value) {
    _spotsListAccY = value;
    notifyListeners();
  }

  set spotsListAccZ(value) {
    _spotsListAccZ = value;
    notifyListeners();
  }

  //button
  bool _isRecording = false;
  bool get isRecording => _isRecording;
  set isRecording(value) {
    _isRecording = value;
    notifyListeners();
  }

  void initHomeView(GlobalKey<ScaffoldState> _scaffoldKey) {
    //_listenToAccelerometerStream();
    //_listenToGyroStream();
    initSpotsList();
    initScaffoldKey(_scaffoldKey);
  }

  void initSpotsList() {
    if (_spotsListAccX == null) {
      _spotsListAccX = List<FlSpot>();
    }
    if (_spotsListAccY == null) {
      _spotsListAccY = List<FlSpot>();
    }
    if (_spotsListAccZ == null) {
      _spotsListAccZ = List<FlSpot>();
    }
    _spotsListAccX.add(FlSpot(0, 0));
    _spotsListAccY.add(FlSpot(0, 0));
    _spotsListAccZ.add(FlSpot(0, 0));
  }

  void initScaffoldKey(GlobalKey<ScaffoldState> _scaffoldKey) =>
      this._scaffoldKey = _scaffoldKey;

  void _listenToAccelerometerStream() {
    _subscriptionAcc = userAccelerometerEvents.listen((data) async {
      _addToSpotsLists(data);
    });
  }

  void _addToSpotsLists(UserAccelerometerEvent data) {
    _counter = _counter + 0.1;
    spotsListAccX.add(FlSpot(_counter, data.x));
    spotsListAccY.add(FlSpot(_counter, data.y));
    spotsListAccZ.add(FlSpot(_counter, data.z));

    spotsListAccX = _spotsListAccX;
    spotsListAccY = _spotsListAccY;
    spotsListAccZ = _spotsListAccZ;
  }

  void _clearSpotsLists() {
    _spotsListAccX.clear();
    _spotsListAccY.clear();
    _spotsListAccZ.clear();
    _spotsListAccX.add(FlSpot(0, 0));
    _spotsListAccY.add(FlSpot(0, 0));
    _spotsListAccZ.add(FlSpot(0, 0));
    _counter = 0;
    notifyListeners();
  }

  // void _listenToGyroStream() {
  //   _subscriptionGyro =
  //       gyroscopeEvents.listen((data) => print(data.toString()));
  // }

  void _pauseAccelerometerStream() {
    _subscriptionAcc.cancel();
  }

  void _resumeAccelerometerStream() {
    _subscriptionAcc.resume();
  }

  void startRecording() {
    isRecording = true;
    _listenToAccelerometerStream();
    _showSnackBar(_scaffoldKey, content: "Recording Started");
  }

  void endRecording() {
    isRecording = false;
    _pauseAccelerometerStream();
    _showSnackBar(_scaffoldKey, content: "Recording Ended");
  }

  void clearGraph() {
    _clearSpotsLists();
    print(_spotsListAccZ.length);
  }

  void _showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, {String content}) {
    scaffoldKey.currentState
        .hideCurrentSnackBar(reason: SnackBarClosedReason.swipe);
    var snackBar = SnackBar(
      content: Text("$content"),
      duration: Duration(seconds: 3),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void handleRecordingButton() {
    print(isRecording ? "Stop" : "Start");
    print(_spotsListAccZ.length);
    if (isRecording) {
      endRecording();
    } else {
      startRecording();
    }
  }
}
