import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  final List<dynamic> monthRequest;
  CustomLineChart({this.monthRequest});
  @override
  _CustomLineChartState createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  // List<FlSpot> sppots = widget.monthRequest.map((e) => FlSpot(
  //                 e['_id']['month'].toDouble(),
  //                 e['nubr'].toDouble());
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.5,
      width: width * 0.9,
      child: LineChart(LineChartData(
        minX: 5,
        maxX: 11,
        minY: 0,
        maxY: 24,
        gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xff37434d),
                strokeWidth: 1,
              );
            }),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
              spots: widget.monthRequest
                  .map((e) => FlSpot(
                      e['_id']['month'].toDouble(), e['nubr'].toDouble()))
                  .toList()
              // FlSpot(widget.monthRequest[0]['_id']['month'].toDouble(),
              //     widget.monthRequest[0]['nubr'].toDouble()),
              // [
              //   // FlSpot(widget.monthRequest[1]['_id']['month'].toDouble(),
              //   //     widget.monthRequest[1]['nubr'].toDouble()),
              // ]
              ),
        ],
      )),
    );
  }
}
