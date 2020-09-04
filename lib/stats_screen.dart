import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  Color color;

  StatsScreen(Color color) {
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    print("hello from business");
    return Scaffold(
      body: Container(
        child: Text("Statistics Page"),
      ),
    );
  }
}
