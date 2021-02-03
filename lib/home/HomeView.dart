import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visualize_threshold_app/home/controllers/accelerometer_controller.dart';

class HomeView extends StatelessWidget {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AccelerometerController accController =
      Get.put(AccelerometerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(title: Text("HomeView")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 130),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: Obx(
                    () => LineChart(
                      LineChartData(
                          titlesData: FlTitlesData(
                            leftTitles: SideTitles(reservedSize: 0),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                                dotData: FlDotData(checkToShowDot: (bar, data) {
                                  return false;
                                }),
                                preventCurveOverShooting: true,
                                isCurved: true,
                                spots: accController.spotsListAccX),
                            LineChartBarData(
                                dotData: FlDotData(checkToShowDot: (bar, data) {
                                  return false;
                                }),
                                isCurved: true,
                                preventCurveOverShooting: true,
                                colors: [Colors.yellow],
                                spots: accController.spotsListAccY),
                            LineChartBarData(
                                dotData: FlDotData(
                                  show: false,
                                ),
                                isCurved: true,
                                preventCurveOverShooting: true,
                                isStrokeCapRound: false,
                                barWidth: 4,
                                colors: [Colors.blue],
                                belowBarData: BarAreaData(show: true, colors: [
                                  ColorTween(
                                          begin: gradientColors[0],
                                          end: gradientColors[1])
                                      .lerp(0.2)
                                      .withOpacity(0.1),
                                  ColorTween(
                                          begin: gradientColors[0],
                                          end: gradientColors[1])
                                      .lerp(0.2)
                                      .withOpacity(0.1),
                                ]),
                                spots: accController.spotsListAccZ)
                          ]),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                        onPressed: accController.clearGraph,
                        child: Text("RESET MAP"),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton(
                          onPressed: accController.handleRecordingButton,
                          child: Obx(
                            () => Text(accController.isRecording.value
                                ? "END RECORDING"
                                : "START RECORDING"),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
