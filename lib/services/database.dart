import 'package:flutter/widgets.dart';

import '../models/habit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/user.dart';
import 'package:intl/intl.dart';


class Database {

  /// File for any database work
  ///
  ///
  ///
  ///
  static final Database _database = Database._internal();
  bool first = true;
  User user;
  var userCollection;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  Map<int, Habit> selectedHabits = {};
  List<Habit> cachedHabits = [];

  List<Habit> habits = [];

  factory Database() {
    return _database;
  }

  void setUser(User user){
    this.user = user;
  }

  void setupUserCollection(){
    this.userCollection = Firestore.instance.collection("users");
  }

  initFirebaseUser(){
    /**
     * Initializes the
     */
  }


  void databaseConstructor() {

    if (_database.first) {
      _database.first = false;

      var date = new DateTime.now();
    }

  }

  void deleteSelectedHabits(){
    for (Habit habit in this.selectedHabits.values){
      this.userCollection.document(this.user.uid).collection('habits').document(habit.hid).delete();
    }
    this.selectedHabits = Map();
  }

  void updateAllHabits() async{
    QuerySnapshot querySnapshot = await this.userCollection.document(this.user.uid).collection('habits').getDocuments();
    var list = querySnapshot.documents;
    for (var ds in list.toList()){
      this.cachedHabits.add(Habit.fromDb1(ds));
    }
//    print(cachedHabits.length);
  }

  void createHabitCollection(String uid, Habit habit){
    /**
     * Creates a collection
     */

    this.userCollection.document(uid).collection('habits').add({
      'name': habit.name,
      'repeating': habit.repeating,
      'repeats':habit.repeats,
      'goal':habit.goal,
      'completed':habit.completed,
      'priority':habit.priority,
      'time': DateTime.now(),
      'completedDates':habit.completedHabitDates,
      'isCompleted':false,
    });
  }

  void generateUserInfo(String uid) async {
    ///Create a user
    ///
    DocumentSnapshot doc = await this.userCollection.document(uid).get();
    int completed = doc['completed'];
    int experience = doc['experience'];
    int daysMissed = doc['daysMissed'];
    //Need to force a single instance of the user
    if(this.user==null){
      this.user = User(uid, completed, experience, daysMissed);
    }
  }

  User getLocalUser(){
    return this.user;
  }


  void createUserInfo(String uid){
    this.setupUserCollection();
    Firestore.instance.collection("users").document(uid).setData(
      {
        "completed":0,
        "experience":0,
        "daysUsed":0,
        "daysMissed": 0,
      },
      merge: true,
    );
  }

  void updateCompletedToday(String uid, Habit habit, bool val){
    /// Upates the completed state of a habit in the database
    ///
    bool isCompleted = false;
    if(habit.completed >= habit.goal){
      isCompleted = true;
    }
    print("updatecompletedtoday");
    print(this.user.experience);
    habit.completedHabitDates[Database().getTodayString()] = val;
    this.userCollection.document(uid).collection('habits').document(habit.hid).updateData({
      "completedDates." + Database().getTodayString() : val,
      "completed" : habit.completed,
      "isCompleted" : isCompleted,
    });
    this.userCollection.document(uid).updateData({
      "completedDates." + Database().getTodayString() : val,
    });
    // If the user completes a habit today,

    if(val){
      print("valtrue");
      this.user.experience = this.user.experience + habit.calculateExperienceIncrease().toInt();
      this.userCollection.document(uid).updateData({
      "experience":this.user.experience,
      });
    }else{
      print("valfalse");
      this.user.experience = this.user.experience - habit.calculateExperienceIncrease().toInt();
      this.userCollection.document(uid).updateData({
      "experience":this.user.experience,
      });
    }
    print(this.user.hashCode);

    print(this.user.experience);


  }


  Database._internal();

  List<Habit> getHabits() {
    return this.habits;
  }

  void printDatabaseHabit(){

  }

  Future getTodaysHabits(String uid) async {
    QuerySnapshot querySnapshot = await this.userCollection.document(uid).collection('habits').getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
//      print(a.documentID);
    }
  }

  Stream<QuerySnapshot> getFrontPageSnapshot(User user){
    /**
     * Gets the snapshot for the front page habit list, only returns
     * habits which are not completed
     */
    return database.userCollection.document(user.uid).collection('habits').where('isCompleted', isEqualTo: false).snapshots();
  }

  Habit addHabit(Habit habit) {
    habits.add(habit);
    return habit;
  }

  DateTime getToday(){
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  String getTodayString(){
    DateTime today = DateTime.now();
    return this.getDateString(DateTime(today.year, today.month, today.day));
  }



  String getDateString(DateTime dt) {
    return dateFormat.format(dt);
  }

  DateTime getDateTimeFromStr(String dt){
    return dateFormat.parse(dt);
  }


  static Database get database => _database;
}
