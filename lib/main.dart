import 'package:flutter/material.dart';
import 'controllers/order_controller.dart';
import 'views/metrics_view.dart';
import 'views/chart_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Orders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, fontFamily: 'Roboto'),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 5, // Shadow effect
            minimumSize: Size(double.infinity, 50),
          ),
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OrderController _controller = OrderController();

  @override
  void initState() {
    super.initState();
    _controller.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _controller.loadOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text("E-Commerce Orders"),
              backgroundColor: Colors.blueAccent,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("E-Commerce Orders"),
              backgroundColor: Colors.blueAccent,
            ),
            body: Center(child: Text("Error loading orders: ${snapshot.error}")),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text("E-Commerce Orders"),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
              elevation: 10,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MetricsView(controller: _controller),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.analytics, size: 24),
                        SizedBox(width: 8),
                        Text('View Order Metrics'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChartView(controller: _controller),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.show_chart, size: 24),
                        SizedBox(width: 8),
                        Text('View Orders Over Time'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
