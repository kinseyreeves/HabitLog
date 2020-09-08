import 'package:flutter/material.dart';
import 'habit.dart';
import 'database.dart';


class ProgressRow extends StatefulWidget {
  Habit habit;
  ProgressRow(this.habit, {Key key}) : super(key: key);

  @override
  _ProgressRow createState() => _ProgressRow(habit);
}


class _ProgressRow extends State{
  Habit habit;

  _ProgressRow(this.habit);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircle(context, true),
        _buildCircle(context, false),
        _buildCircle(context, false),
        _buildCircle(context, false),
        _buildCircle(context, false)
      ],
    );
  }

  Widget _buildCircle(BuildContext context, bool completed){
    return Container(
      padding: EdgeInsets.all(2.0),
      child: SizedBox(
        width: 15,
        height: 15,
        child: CustomPaint(
          painter: CirclePainter(completed),
        ),
      ),
    );
  }

}



class CirclePainter extends CustomPainter {
  bool completed;
  final _paint = Paint()
    ..color = Colors.black12
    ..strokeWidth = 2
  // Use [PaintingStyle.fill] if you want the circle to be filled.

    ..style = PaintingStyle.stroke;

  CirclePainter(bool completed) {
    this.completed = completed;
    if (completed) {
      _paint.style = PaintingStyle.fill;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}