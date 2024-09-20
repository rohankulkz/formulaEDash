import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geri_flutter_dash/chartData.dart';

import "package:geri_flutter_dash/main.dart" as mainEngine;
import 'package:geri_flutter_dash/tableGenerator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

Container buildUsersWidget(int userCount) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: mainEngine.mainThemeBlack),
    width: 300,
    height: 180,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: 25, top: 25, right: 0, bottom: 0),
              child: SelectableText(
                "Total Entries",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 0, top: 25, right: 15, bottom: 0),
              child: Icon(
                Icons.people,
                color: Colors.white,
                size: 55,
              ),
            )
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 25, top: 5, right: 0, bottom: 0),
          child: Text(
            "$userCount",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        )
      ],
    ),
  );
}


double getMax(List<double> data){
  double max = 0;

  for(double d in data){
    if(d>max){
      max = d;
    }
  }

  return max;
}


double getMin(List<double> data){
  double min = 1000000000000000000;

  for(double d in data){
    if(d<min){
      min = d;
    }
  }

  return min;
}

Container usageGraph(List<List<String>> loadedData, VoidCallback refresh, List<String> graphOptions, void Function(int,int,int) indexController, int tag, int Function(int,int) getIndex,
    CrosshairBehavior crosshairBehavior, ZoomPanBehavior zoomPanBehavior) {


  if(loadedData.length <= 1){
    return analyticsShell(loadedData);
  }

  loadedData = loadedData.sublist(1,loadedData.length);


  List<double> xValues = getColumn(loadedData, getIndex(tag,0));
  List<double> yValues = getColumn(loadedData, getIndex(tag,1));


  double minX = getMin(xValues);
  double maxX = getMax(xValues);
  double minY = getMin(yValues);
  double maxY = getMax(yValues);

  List<ChartData> data = [];

  for(int i = 0; i<xValues.length; i++){
    data.add(ChartData(xValues[i], yValues[i]));
  }



  return Container(
    width: 630,
    height: 400,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
        borderRadius: BorderRadius.circular(25)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25, bottom: 0, right: 0, left: 25),
              child: SelectableText(
                "Graph " + tag.toString() + " (x,y)",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 25, bottom: 0, left: 0, right: 25),
                child: Row(
                  children: [
                    DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            alignment: Alignment.centerLeft,
                            borderRadius: BorderRadius.circular(29),
                            value: graphOptions[getIndex(tag,0)],
                            items: graphOptions.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (String? value) {


                              indexController(tag, 0, graphOptions.indexOf(value!));
                              refresh();

                              // This is called when the user selects an item.

                            }

                            )
                    ),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            alignment: Alignment.centerLeft,
                            borderRadius: BorderRadius.circular(29),
                            value: graphOptions[getIndex(tag,1)],
                            items: graphOptions.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                            onChanged: (String? value) {
                              indexController(tag, 1, graphOptions.indexOf(value!));
                              refresh();
                              // This is called when the user selects an item.
                            }
                        )
                    )
                  ],
                ))
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: 25, top: 25, bottom: 0, right: 25),
            child: SfCartesianChart(
              crosshairBehavior: crosshairBehavior,
                zoomPanBehavior: zoomPanBehavior,
                primaryXAxis: NumericAxis(
                  minimum: minX, maximum: maxX, interval: (maxX-minX)/25, interactiveTooltip: InteractiveTooltip(enable: true),
                  title:  AxisTitle(text: graphOptions[getIndex(tag,0)])
                ),
                primaryYAxis: NumericAxis(
                    minimum: minY, maximum: maxY, interval: (maxY-minY)/25, title:
                AxisTitle(text: graphOptions[getIndex(tag,1)])),
                series: <ChartSeries<ChartData, double>>[
                  LineSeries<ChartData, double>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      name: 'Graph',
                      color: mainEngine.mainThemeBlack)
                ]
            )
        ),
      ],
    ),
  );
}

Container analyticsShell(List<List<String>> data) {
  return Container(
    width: 630,
    height: 400,
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.4), width: 0.5),
        borderRadius: BorderRadius.circular(25)),
  );
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
