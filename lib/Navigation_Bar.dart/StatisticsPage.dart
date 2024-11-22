import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<LineChartBarData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchStatistics();
  }

  Future<void> fetchStatistics() async {
    String userId = "user_1";
    CollectionReference dailyMoodsCollection =
        _firestore.collection('moodData').doc(userId).collection('dailyMoods');

    QuerySnapshot snapshot = await dailyMoodsCollection.get();

    if (snapshot.docs.isNotEmpty) {
      List<double> moodData = [];
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('value')) {
          moodData.add(data['value'] as double);
        }
      }

      print("Mood Data: $moodData");

      chartData = [
        LineChartBarData(
          spots: moodData
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList(),
          isCurved: true,
          color: Colors.blue,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      ];

      setState(() {});
    } else {
      print("No data found in dailyMoods collection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإحصائيات'),
      ),
      body: chartData.isEmpty
          ? Center(child: Text('لا توجد بيانات لعرضها'))
          : LineChartWidget(chartData: chartData),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<LineChartBarData> chartData;

  const LineChartWidget({
    required this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          gridData: FlGridData(show: true),
          lineBarsData: chartData,
        ),
      ),
    );
  }
}
