import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const ChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double total = data.fold(
        0, (previousValue, element) => previousValue + (element['amount'] as double));

    return data.isEmpty
        ? const Center(child: Text('No data available.'))
        : PieChart(
            PieChartData(
              sections: data.map((item) {
                final value = item['amount'] as double;
                final title = item['category'] as String;
                final percent = (total == 0) ? 0 : ((value / total) * 100);

                return PieChartSectionData(
                  value: value,
                  title: "${percent.toStringAsFixed(1)}%",
                  color: Colors.accents[data.indexOf(item) % Colors.accents.length],
                  radius: 60,
                  titleStyle: const TextStyle(
                      fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                );
              }).toList(),
            ),
          );
  }
}
