import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:sensors/sensors.dart';

class AccelerometerController extends GetxController {
  StreamSubscription<UserAccelerometerEvent> _subscriptionAcc;
  // List<FlSpot> _spotsListAccX;
  // List<FlSpot> _spotsListAccY;
  // List<FlSpot> _spotsListAccZ;
  // List<FlSpot> get spotsListAccX => _spotsListAccX;
  // List<FlSpot> get spotsListAccZ => _spotsListAccZ;
  // List<FlSpot> get spotsListAccY => _spotsListAccY;
  double _counter = 0.0;

  List<FlSpot> spotsListAccX;
  List<FlSpot> spotsListAccY;
  List<FlSpot> spotsListAccZ;

  // set spotsListAccX(value) {
  //   _spotsListAccX = value;
  // }

  // set spotsListAccY(value) {
  //   _spotsListAccY = value;
  // }

  // set spotsListAccZ(value) {
  //   _spotsListAccZ = value;
  // }

  //button
  var isRecording = false.obs;
  

  @override
  void onInit() {
    initSpotsList();
    super.onInit();
  }

  void initSpotsList() {
    if (spotsListAccX == null) {
      spotsListAccX = List<FlSpot>().obs;
    }
    if (spotsListAccY == null) {
      spotsListAccY = List<FlSpot>().obs;
    }
    if (spotsListAccZ == null) {
      spotsListAccZ = List<FlSpot>().obs;
    }
    spotsListAccX.add(FlSpot(0, 0));
    spotsListAccY.add(FlSpot(0, 0));
    spotsListAccZ.add(FlSpot(0, 0));
  }

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

    // spotsListAccX = spotsListAccX;
    // spotsListAccY = spotsListAccY;
    // spotsListAccZ = spotsListAccZ;
  }

  void _clearSpotsLists() {
    spotsListAccX.clear();
    spotsListAccY.clear();
    spotsListAccZ.clear();
    spotsListAccX.add(FlSpot(0, 0));
    spotsListAccY.add(FlSpot(0, 0));
    spotsListAccZ.add(FlSpot(0, 0));
    _counter = 0;
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
    isRecording.value = true;
    _listenToAccelerometerStream();
    _showSnackBar(content: "Recording Started");
  }

  void endRecording() {
    isRecording.value = false;
    _pauseAccelerometerStream();
    _showSnackBar(content: "Recording Ended");
  }

  void clearGraph() {
    _clearSpotsLists();
    print(spotsListAccZ.length);
  }

  void _showSnackBar({String content}) {
    Get.snackbar("Recording",content,duration: Duration(seconds:3));
    // scaffoldKey.currentState
    //     .hideCurrentSnackBar(reason: SnackBarClosedReason.swipe);
    // var snackBar = SnackBar(
    //   content: Text("$content"),
    //   duration: Duration(seconds: 3),
    // );
    // scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void handleRecordingButton() {
    print(isRecording.value ? "Stop" : "Start");
    print(spotsListAccZ.length);
    if (isRecording.value) {
      endRecording();
    } else {
      startRecording();
    }
  }
}
