import 'habit.dart';

class Database {
  static final Database _database = Database._internal();
  bool first = true;

  List<Habit> habits = new List<Habit>();

  factory Database() {
    return _database;
  }

  void setupHabits() {
    Habit workout = new Habit(
        "Workout", true, [true, false, false, true, true, true, true], 3, 4);
    if (_database.first) {
      _database.first = false;
      print("happens once");

      habits.add(workout);

      habits.add(new Habit("Walk Dog", true,
          [true, false, true, false, true, false, true], 5, 4));

      var date = new DateTime.now();
      print("${date.weekday}");
    }
    print("done");
    DateTime dt1 = DateTime(2020,9,4);
    DateTime dt2 = DateTime(2020,9,5);
    DateTime dt3 = DateTime(2020,9,6);

    workout.completedHabitDates[dt1] = true;
    workout.completedHabitDates[dt2] = true;
    workout.completedHabitDates[dt3] = true;
    workout.completedHabitDates[dt3] = true;
    workout.completedHabitDates[getToday()] = true;

    print("done2");
    print(workout.getPreviousDates(getToday()));
  }

  Database._internal();

  List<Habit> getHabits() {
    return this.habits;
  }

  List<Habit> getTodaysHabits() {}

  void addHabit(Habit habit) {
    habits.add(habit);
  }

  DateTime getToday(){
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  String getDateString(DateTime dt) {
    return dt.year.toString() +"/"+ dt.month.toString() +"/"+ dt.day.toString();
  }

  static Database get database => _database;
}
