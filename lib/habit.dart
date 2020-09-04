class Habit {

  String _name;
  bool _repeating;
  List<bool> _repeats;
  int _goal;
  double _priority;
  int _completed;
  Map completedDates = new Map();

  Habit(
      this._name, this._repeating, this._repeats, this._goal, this._priority) {
    _completed = 0;
  }

  bool habitRunsToday(){
    int dayIndex = new DateTime.now().weekday-1;
    return _repeats[dayIndex];
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
