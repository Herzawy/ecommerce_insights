import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';

class MetricsView extends StatelessWidget {
  final OrderController controller;

  MetricsView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final metrics = controller.getOrderMetrics();

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Metrics"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCard(
              context,
              icon: Icons.shopping_cart,
              title: "Total Orders",
              value: metrics['totalCount'].toString(),
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            _buildMetricCard(
              context,
              icon: Icons.attach_money,
              title: "Average Price",
              value: "\$${metrics['averagePrice'].toStringAsFixed(2)}",
              color: Colors.green,
            ),
            SizedBox(height: 20),
            _buildMetricCard(
              context,
              icon: Icons.refresh,
              title: "Returns",
              value: metrics['returnsCount'].toString(),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, {required IconData icon, required String title, required String value, required Color color}) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
