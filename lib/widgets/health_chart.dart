import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HealthChart extends StatelessWidget {
  final List<Map<String, dynamic>> healthData;

  const HealthChart({super.key, required this.healthData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: healthData
                  .asMap()
                  .entries
                  .map((entry) => FlSpot(
                        entry.key.toDouble(),
                        entry.value['steps'].toDouble(),
                      ))
                  .toList(),
              isCurved: true,
              color: Colors.pink,
              barWidth: 3,
              belowBarData: BarAreaData(show: true, color: Colors.pink.withOpacity(0.3)),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
