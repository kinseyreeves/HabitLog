import 'database.dart';

class Habit {
  String _name;
  bool _repeating;
  List<bool> _repeats;
  int _goal;
  double _priority;
  int _completed;
  Map habitDates = new Map();
  Database database;

  Habit(
      this._name, this._repeating, this._repeats, this._goal, this._priority) {
    _completed = 0;
    database = Database();

    //create forward map of datetimes
    int weeklyTrue = _repeats.where((item) => item == true).length;
    int i = 0;
    while (i < _goal) {
      var today = DateTime.now();
      i += 1;
      //Todo, forward through all dates where habit occurs marking it in habitDates
    }
  }

  bool habitRunsToday() {
    int dayIndex = new DateTime.now().weekday - 1;
    return _repeats[dayIndex];
  }

  void completeHabit() {
    String date = database.getDateString();
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
