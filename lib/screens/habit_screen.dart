import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/database.dart';
import '../progress_row.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:percent_indicator/percent_indicator.dart';



class HabitScreen extends StatefulWidget {
  HabitScreenState habitScreenState;
  User user;
  AuthService authService;
  MainScreenState mainScreenState;
  HabitScreen(MainScreenState mainScreenState){
    this.mainScreenState = mainScreenState;
    this.user = user;
    this.authService = new AuthService();
    this.habitScreenState = new HabitScreenState();
      // do some operation
  }
  @override
  HabitScreenState createState() => HabitScreenState();

  HabitScreenState getState() => this.habitScreenState;
}

class HabitScreenState extends State<HabitScreen> {
  User user;
  Database database;
  List<Habit> habits;
  int selectedItem = -1;
  MainScreenState mainScreenState;
  
  bool showTodaysHabits = true;

  List<int> selectedItems = [];


  HabitScreenState() {
    //this.user = widget.user;
//
    database = Database();
    habits = Database().getHabits();
  }


  @override
  Widget build(BuildContext context) {
    this.mainScreenState = widget.mainScreenState;
    final user = Provider.of<User>(context);
    this.user = user;

    if(user!=null) {
      print("BUILDING exp" + database.user.experience.toString());
//      print(this.showTodaysHabits);
      database.setupUserCollection();
      database.setUser(this.user);
      database.getTodaysHabits(this.user.uid);
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateReturnHabit(context);
          },
          child: Icon(Icons.add),
        ),
        body:Column(
          children: [
            generateStatusBar(),
            Expanded(
                child: generateList(),
            ),
          ]
        )

      );

    }else{
      return CircularProgressIndicator();
    }
  }

  Widget generateStatusBar(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Level " + this.user.getUserLevel().toString()),
            progressBar(),
            progressSwitch()
          ],
        )
    );
  }

  Widget progressBar(){
//    print("rebuilding bar");
    return LinearPercentIndicator(
      width: 100.0,
      lineHeight: 8.0,
      percent: this.user.getPercentNextLevel(),
      progressColor: Colors.blue,
    );
  }

  Widget progressSwitch(){
    return Switch(value: showTodaysHabits, onChanged: (value){

      setState(() {
        this.showTodaysHabits = value;
      });

    },);
  }

  StreamBuilder generateList(){
    return StreamBuilder<QuerySnapshot>(
      stream: database.getFrontPageSnapshot(user),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data.documents[index];
              Habit habit = Habit.fromDb1(ds);
              //TODO ideally its not populated at all

              if(!habit.habitRunsToday() && this.showTodaysHabits){
                print(habit.name);
                return Container(width: 0,height: 0,);
              }
              return GestureDetector(
                  onTap: () {
//                    print("tapped");
                  },
                  onLongPress: (){
//                    print("long pressed");
                    setState(() {
                      if(this.database.selectedHabits.containsKey(index)){
                        this.database.selectedHabits.remove(index);
                      }else{
                        this.database.selectedHabits[index] = habit;
                      }
                      this.mainScreenState.resetAppBar();
                    });
                  },
                  child: this.generateCard(habit, index)
              );
            },
          );
        } else if (snapshot.hasError) {
          return CircularProgressIndicator();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }


  Card generateCard(Habit habit, int index) {
    /**
     * Generates a card for the list view
     *
     **/

    bool checkboxValue = habit.isCompletedToday();
    bool containsCheckbox = habit.habitRunsToday();

    Color color;

    if(this.database.selectedHabits.containsKey(index)){
      color = Colors.blue;
    }else{
      color = Colors.white;
    }

    return new Card(
      color: color,
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
          ProgressRow(habit),
          Container(
            child: new Checkbox(
                value: checkboxValue,
                activeColor: Colors.blue,
                onChanged: (bool newValue) {
                  setState(() {
                    if(newValue){
                      habit.completed+=1;
                    }else{
                      habit.completed-=1;
                    }
                    database.updateCompletedToday(database.user.uid, habit, newValue);
                  });
                  Text('Remember me');
                }),
          )
        ],
      ),
    ));
  }

  Widget _buildCircle(BuildContext context, bool completed) {
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

  navigateReturnHabit(BuildContext context) async {
    /**
     * Async function which starts the named route
     */
    final result = await Navigator.pushNamed(context, '/add_habit', arguments: {'User': this.user});
    if (result != null) {
      Habit habit = database.addHabit(result);
      database.createHabitCollection(this.user.uid, habit);
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





