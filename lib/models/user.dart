import '../models/habit.dart';

class User {
  /**
   * User class which contains user info and user statistics about
   *  their habit usage.
   */
  String uid;
  int completed;
  int experience;
  int daysMissed;
  List<int> levelBoundaries;
  int level;
  double percentNextLevel;

  User(String uid, int completed, int experience, int daysMissed){
    this.uid = uid;
    this.completed = completed;
    this.experience = experience;
    this.daysMissed = daysMissed;
    this.levelBoundaries = calculateLevelBoundaries();
    this.level = getUserLevel();
    this.percentNextLevel = getPercentNextLevel();

  }

  List<int> calculateLevelBoundaries(){
    List<int> levelBoundaries = [];
    double multipler = 1.04;
    int currentExp = 100;
    int sum = 0;
    for (int i = 1; i <= 100; i++){
      currentExp = (currentExp*multipler).ceil().toInt();
      sum+=currentExp;
      levelBoundaries.add(sum);
    }
    return levelBoundaries;
  }

  double getPercentNextLevel(){
    print("Getting percent");
    print(this.levelBoundaries);
    this.level = this.getUserLevel();
    print(this.level);
    int expReq;
    int levelExp;
    if(this.level == 0){
      expReq = this.levelBoundaries[this.level];
      levelExp = this.experience;
    }
    else {
      expReq = this.levelBoundaries[this.level] -
          this.levelBoundaries[this.level-1];
      levelExp = this.experience - this.levelBoundaries[this.level-1];
    }
//    print(expReq);
//    print(levelExp);
      return levelExp/expReq;

  }

  void printUser(){
   print(this.uid);
   print(this.completed);
   print(this.experience);
   print(this.daysMissed);
  }


  int getUserLevel(){
    for (int i = 0; i < this.levelBoundaries.length; i++){
      if (this.experience < this.levelBoundaries[i]){
        return i;
      }
    }
    return 100;
  }


}