import 'package:flutter/material.dart';
import 'habit.dart';
import 'database.dart';
import 'package:weekday_selector/weekday_selector.dart';

class HabitScreen extends StatefulWidget {
  final Color color;
  HabitScreenState habitScreenState;

  HabitScreen(this.color) {
    this.habitScreenState = new HabitScreenState(Colors.red);
  }

  @override
  HabitScreenState createState() => HabitScreenState(color);
}

class HabitScreenState extends State {
  final Color color;

  Database database;
  List<Habit> habits;

  HabitScreenState(this.color) {
    database = Database();
    habits = Database().getHabits();
  }

  @override
  Widget build(BuildContext context) {
    print(this.habits);
    ListView habitList = this.getHabitList();
//    ListView habitList = new ListView.builder(
//      itemCount: this.habits.length,
//      itemBuilder: (BuildContext ctxt, int index){
//        return new Text(this.habits[index].name);
//      },
//    );
    print("hello from habit screen number of habits" +
        this.habits.length.toString());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateReturnHabit(context);
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: habitList,
      ),
    );
  }

  ListView getHabitList() {
    /**
     * Generates the list of habits for the front page
     **/
    ListView habitList = new ListView.builder(
      itemCount: this.habits.length,
      itemBuilder: (BuildContext context, int index) {
        return generateCard(index);
        //return new Text(this.habits[index].name);
      },
    );
    return habitList;
  }

  Card generateCard(int index) {
    /**
     * Generates a card for the list view
     *
     **/
    Habit habit = this.habits[index];


    return new Card(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80,
            child: Column(
              children: [
                Text(
                  habit.name,
                  style: TextStyle(fontSize: 18),
                ),
                Text(habit.completed.toString() + "/" + habit.goal.toString()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCircle(context, true),
              _buildCircle(context, false),
              _buildCircle(context, false)
            ],
          ),
          Container(
            child: new Checkbox(
                value: true,
                activeColor: Colors.blue,
                onChanged: (bool newValue) {
                  setState(() {
                    //checkBoxValue = newValue;
                  });
                  Text('Remember me');
                }),
          )
        ],
      ),
    )
//            ListTile(
//              title:Text(this.habits[index].name),
//            )
        );
  }

  Widget _buildCircle(BuildContext context, bool completed) {
    return Container(
      padding: EdgeInsets.all(2.0),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CustomPaint(
          painter: CirclePainter(completed),
        ),
      ),
    );
  }

  navigateReturnHabit(BuildContext context) async {
    /**
     *
     */
    final result = await Navigator.pushNamed(context, '/second');
    if (result != null) {
      database.addHabit(result);
    }
    setState(() {});
  }
}

class CirclePainter extends CustomPainter {
  bool completed;
  final _paint = Paint()
    ..color = Colors.black12
    ..strokeWidth = 2
  // Use [PaintingStyle.fill] if you want the circle to be filled.

    ..style = PaintingStyle.stroke;

  CirclePainter(bool completed){
    this.completed = completed;
    if(completed){
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
