import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:visualize_threshold_app/home/HomeViewModel.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeView extends StatelessWidget {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //appBar: AppBar(title: Text("HomeView")),
      body: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(),
        onModelReady: (model) => model.initHomeView(_scaffoldKey),
        builder: (context, model, _) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top:130),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: LineChart(
                      
                      LineChartData(titlesData: FlTitlesData(
                        leftTitles: SideTitles(reservedSize: 0),
                      ),lineBarsData: [
                        LineChartBarData(
                            dotData: FlDotData(checkToShowDot: (bar, data) {
                              return false;
                            }),
                            preventCurveOverShooting: true,
                            isCurved: true,
                            spots: model.spotsListAccX),
                        LineChartBarData(
                            dotData: FlDotData(checkToShowDot: (bar, data) {
                              return false;
                            }),
                            isCurved: true,
                            preventCurveOverShooting: true,
                            colors: [Colors.yellow],
                            spots: model.spotsListAccY),
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
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2).withOpacity(0.1),
              ]),
                            spots: model.spotsListAccZ)
                      ]),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          onPressed: model.clearGraph,
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
                          onPressed: model.handleRecordingButton,
                          child: Text(model.isRecording
                              ? "END RECORDING"
                              : "START RECORDING"),
                        ),
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
      ),
    );
  }
}
