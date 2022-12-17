
class LevelsModel{
  var id;
  var level;
  var date_created;
  var subjects;

  LevelsModel(
      this.id,
      this.level,
      this.date_created,
      this.subjects
      );

  factory LevelsModel.fromJson(Map<String, dynamic> json){
    return LevelsModel(
        json['id'],
        json['levels'],
        json['date_created'],
        json['subjects']
    );
  }
}