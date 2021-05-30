import 'package:flutter/material.dart';
import 'screens/habit_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/add_habit.dart';
import 'models/habit.dart';
import 'services/database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'screens/calendar_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth.dart';
import 'screens/login.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';



void main() async{
//  print("Start");
  WidgetsFlutterBinding.ensureInitialized();


  //Database connection
  Database database = new Database();
  database.databaseConstructor();

  //User authentication
  final AuthService _auth = AuthService();

  //sign out for debugging
  //_auth.signOut();
  bool isLogged = await _auth.isLogged();
  database.setupUserCollection();
  database.generateUserInfo(_auth.firebaseUID);


  runApp(MaterialApp(
    title: 'Habit log',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    //initialRoute: initialRoute,
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => LandingPage(),
      '/add_habit': (context) => AddHabitScreenWidget(),
      '/login' : (context) => Login(),
      '/home': (context) => MainScreen(),
    },
  ));
}


class LandingPage extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    _auth.isLogged().then((success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreenState state = new MainScreenState();

  @override
  MainScreenState createState() {
    return state;
  }
}

class MainScreenState extends State {

  int currentTabIndex = 0;
  HabitScreen habitScreen;
  StatsScreen statsScreen;
  CalendarScreen calendarScreen;
  List<Widget> tabs;

  bool _initialized = false;
  bool _error = false;

  MainScreenState() {
    this.habitScreen = new HabitScreen(this);
    this.statsScreen = new StatsScreen();
    this.calendarScreen = new CalendarScreen();
    tabs = [
      this.getHabitScreen(),
      this.getBusinesScreen(),
      this.getCalendarScreen(),
    ];
  }
  Widget deleteIcon = Container();

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
//      print(index);
    });
  }

  @override
  Widget build(BuildContext context) {

    return StreamProvider<User>.value(
      value:AuthService().user,
      child: Scaffold(
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
          actions: <Widget>[
            FlatButton.icon(
              icon:Icon(Icons.person),
              label: Text('logout'),
              onPressed: (){
                final AuthService _auth = AuthService();
                _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            this.deleteIcon,
          ]
        ),
        body: tabs[currentTabIndex],
      )

    );
  }

  void resetAppBar(){
    ///Used to reset the app bar (add delete button etc)

//    print("RESETTING APP BAR");
    if (Database.database.selectedHabits.length > 0){
      this.deleteIcon = FlatButton.icon(icon:Icon(Icons.delete),
        onPressed: (){
          Database.database.deleteSelectedHabits();
          setState(() {
            this.deleteIcon = Container();
          });
        },
        label: Text(''),
      );
    }else{
      this.deleteIcon = Container();
    }
    setState(() {

    });

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
