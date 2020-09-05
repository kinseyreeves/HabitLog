import 'package:flutter/material.dart';
import 'habit_screen.dart';
import 'stats_screen.dart';
import 'add_habit.dart';
import 'habit.dart';
import 'database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calendar_screen.dart';

void main() {
  print("Start");
  FirstScreen fs = new FirstScreen();
  Database database = Database();
  database.setupHabits();

  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => fs,
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => AddHabitScreenWidget(),
    },
  ));
}

class FirstScreen extends StatefulWidget {
  FirstScreenState state = new FirstScreenState();

  @override
  FirstScreenState createState() {
    print(state.hashCode);
    return state;
  }
}

class FirstScreenState extends State {
  int currentTabIndex = 0;
  HabitScreen habitScreen;
  StatsScreen statsScreen;
  CalendarScreen calendarScreen;
  List<Widget> tabs;

  FirstScreenState() {
    this.habitScreen = new HabitScreen();
    this.statsScreen = new StatsScreen();
    this.calendarScreen = new CalendarScreen();
    tabs = [
      this.getHabitScreen(),
      this.getBusinesScreen(),
      this.getCalendarScreen(),
    ];
  }

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTapped,
          currentIndex: currentTabIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Habits'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              title: Text('Statistics'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Calendar'),
            ),
          ]),
      appBar: AppBar(
        title: Text('Habit Log'),
      ),
      body: tabs[currentTabIndex],
    );
  }

  CalendarScreen getCalendarScreen() {
    return this.calendarScreen;
  }

  HabitScreen getHabitScreen() {
    return this.habitScreen;
  }

  getBusinesScreen() {
    return this.statsScreen;
  }
}
