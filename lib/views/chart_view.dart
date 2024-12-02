import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/order_controller.dart';

class ChartView extends StatefulWidget {
  final OrderController controller;

  const ChartView({required this.controller, Key? key}) : super(key: key);

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  static const double barWidth = 7;
  int touchedGroupIndex = -1;
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  double maxY = 0;

  @override
  void initState() {
    super.initState();
    rawBarGroups = [];
    showingBarGroups = [];
    _loadData();
  }

  /// Load data asynchronously and prepare bar chart groups.
  Future<void> _loadData() async {
    try {
      await widget.controller.loadOrders();
      final barGroups = widget.controller.getOrdersOverTime();

      setState(() {
        rawBarGroups = barGroups;
        showingBarGroups = List.of(rawBarGroups);
        maxY = barGroups
            .map((group) => group.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b))
            .reduce((a, b) => a > b ? a : b);
        maxY += 5;
      });
    } catch (e) {
      debugPrint("Error loading data for chart: $e");
      setState(() {
        rawBarGroups = [];
        showingBarGroups = [];
      });
    }
  }

  /// Build the UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders Over Time"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: rawBarGroups.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : rawBarGroups.isEmpty
            ? const Center(child: Text("No Data Available"))
            : BarChart(
          BarChartData(
            maxY: maxY,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY}',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
              touchCallback: (FlTouchEvent event, response) {
                if (response == null || response.spot == null) {
                  setState(() {
                    touchedGroupIndex = -1;
                    showingBarGroups = List.of(rawBarGroups);
                  });
                  return;
                }

                setState(() {
                  touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                  showingBarGroups = List.of(rawBarGroups);
                  if (touchedGroupIndex != -1) {
                    final avg = showingBarGroups[touchedGroupIndex]
                        .barRods
                        .map((rod) => rod.toY)
                        .reduce((a, b) => a + b) /
                        showingBarGroups[touchedGroupIndex].barRods.length;
                    showingBarGroups[touchedGroupIndex] =
                        showingBarGroups[touchedGroupIndex].copyWith(
                          barRods: showingBarGroups[touchedGroupIndex]
                              .barRods
                              .map((rod) => rod.copyWith(toY: avg, color: Colors.orange))
                              .toList(),
                        );
                  }
                });
              },
            ),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final monthNames = [
                      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                    ];
                    return Text(
                      monthNames[value.toInt() % 12],
                      style: const TextStyle(fontSize: 12),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: showingBarGroups,
            gridData: const FlGridData(show: false),
          ),
        ),
      ),
    );
  }
}
