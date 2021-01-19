import 'dart:collection';

import 'database.dart';
import 'package:sortedmap/sortedmap.dart';


class Habit {
  ///Habit Class containing all information for habits
  ///
  String _name;
  bool _repeating;
  List<bool> _repeats;
  int _goal;
  double _priority;
  int _completed;
//  Map completedHabitDates = new LinkedHashMap<String, bool>();
  SortedMap completedHabitDates = new SortedMap<DateTime, bool>(Ordering.byKey());
  Database database;

  Habit(
      this._name, this._repeating, this._repeats, this._goal, this._priority) {
    _completed = 0;
    database = Database();

    int weeklyTrue = _repeats.where((item)  => item == true).length;
    print(weeklyTrue);
    var today = DateTime.now();
    int i = 0;
    while (i < _goal) {
      if(_repeats[today.weekday-1]){
        String dayString = database.getDateString(today);
        completedHabitDates[today]=false;
        i += 1;
      }
      DateTime tomorrow = DateTime(today.year, today.month, today.day+1);
      today=tomorrow;
    }
    print(this.name);
    print("Checking map");
    print(completedHabitDates);
    //print(completedHabitDates[]);
  }



  bool habitRunsToday() {
    /// Whether or not the habit runs today
    ///
    int dayIndex = new DateTime.now().weekday - 1;
    return _repeats[dayIndex];
  }

  List getPreviousDates(DateTime dt){
    ///
    /// Gets the previous dates from a datetime contained in the habit
    /// Returns a list of length 7.
    List list = new List<bool>();

    if(this.completedHabitDates.containsKey(dt)){
      DateTime key = this.completedHabitDates.lastKeyBefore(dt);
      list.add(this.completedHabitDates[key]);
      int i = 0;
      while (i<10 && key!=null){
        key = this.completedHabitDates.lastKeyBefore(key);
        if(key!=null){
          list.add(this.completedHabitDates[key]);
        }
        i+=1;
      }

    }

    return list;
  }

  void completeHabit(DateTime dt) {
    /// Completes a habit on a specific date
    ///
    if(completedHabitDates.containsKey(dt)){
      completedHabitDates[dt] = true;
    }
  }

  //getters and setters

  set completed(int value) {
    _completed = value;
  }

  int get completed => _completed;

  List<bool> get repeats => _repeats;

  set repeats(List<bool> value) {
    _repeats = value;
  }

  double get priority => _priority;

  int get goal => _goal;

  bool get repeating => _repeating;

  String get name => _name;
}
