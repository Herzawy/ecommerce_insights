import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/order.dart';

class OrderController {
  List<Order> orders = [];

  Future<void> loadOrders() async {
    try {
      final String response = await rootBundle.loadString('assets/orders.json');
      final List<dynamic> data = json.decode(response);
      orders = data.map((e) => Order.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error loading orders: $e");
      orders = [];
    }
  }

  Map<String, dynamic> getOrderMetrics() {
    if (orders.isEmpty) return {'totalCount': 0, 'averagePrice': 0.0, 'returnsCount': 0};

    int totalCount = orders.length;
    int activeCount = orders.where((order) => order.isActive).length;
    double totalPrice = orders.fold(0, (sum, order) => sum + order.priceValue);
    double averagePrice = totalPrice / totalCount;
    int returnsCount = orders.where((order) => order.status == "RETURNED").length;

    return {
      'totalCount': totalCount,
      'activeCount': activeCount,
      'averagePrice': averagePrice,
      'returnsCount': returnsCount,
    };
  }

  List<BarChartGroupData> getOrdersOverTime() {
    if (orders.isEmpty) return [];

    DateTime currentDate = DateTime.now();
    Map<int, int> monthlyOrders = {};

    for (var order in orders) {
      DateTime orderDate = DateTime.parse(order.registered);

      if (orderDate.year >= currentDate.year - 5) {
        int monthKey = orderDate.month + (orderDate.year - currentDate.year + 5) * 12;

        monthlyOrders[monthKey] = (monthlyOrders[monthKey] ?? 0) + 1;
      }
    }

    // Convert monthly order counts to BarChartGroupData.
    return monthlyOrders.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: entry.value.toDouble(),
            color: Colors.blue,
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  Map<String, int> getOrderStatusCounts() {
    Map<String, int> counts = {
      'ORDERED': 0,
      'DELIVERED': 0,
      'RETURNED': 0,
    };

    for (var order in orders) {
      if (counts.containsKey(order.status)) {
        counts[order.status] = counts[order.status]! + 1;
      }
    }

    return counts;
  }
}