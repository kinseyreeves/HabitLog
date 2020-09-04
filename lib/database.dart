import 'habit.dart';

class Database {
  static final Database _database = Database._internal();
  bool first = true;

  List<Habit> habits = new List<Habit>();

  factory Database() {

    return _database;
  }

  void setupHabits(){
    if (_database.first) {
      _database.first = false;
      print("happens once");
      habits.add(new Habit("Workout", true, [true, true, true, true, true, true, true], 10, 4));
    }
  }

  Database._internal();

  List<Habit> getHabits() {
    return this.habits;
  }

  List<Habit> getTodaysHabits(){
    
  }

  void addHabit(Habit habit) {
    habits.add(habit);
  }

  String getDateString(){
    return DateTime.now().toString();
  }



  static Database get database => _database;
}
