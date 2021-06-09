import 'dart:math' as Math;

import 'jp_map_chart.dart';
import 'pref_list.dart';
import 'package:flutter/material.dart';

class JpMapChartData {
  Map<Prefecture,ChartData> dataMap;
  JpMapChartData(this.dataMap);

  static JpMapChartData fromStatistics(List<JpStatisticsValue> statistics) {
    //var minValue = double.infinity;
    var maxValue = 0.0;
    for(var s in statistics) {
      //minValue = Math.min(minValue, s.value);
      maxValue = Math.max(maxValue, s.value);
    }
    var factor = 255.0 / maxValue;
    Map<Prefecture,ChartData> dataMap = {};
    for(var s in statistics) {
      //print("${s.pref}: ${(255-s.value*factor).floor()}");
      dataMap[s.pref] = ChartData(Color.fromARGB(255, 255,
          Math.max(0,(255-s.value*factor).floor()),
        Math.max(0,(255-s.value*factor).floor()),
      ));
    }
    return JpMapChartData(dataMap);
  }
}

class JpStatisticsValue {
  final Prefecture pref;
  final double value;
  JpStatisticsValue(this.pref, this.value);
}
