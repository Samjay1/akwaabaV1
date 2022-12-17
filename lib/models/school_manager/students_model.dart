
class StudentsModel{
  var id;
  var student_name;
  var profile_image;
  var year_start;
  var year_end;
  var date_created;
  var class_assigned;
  var subjects_assigned;
  var score;
  var remarks;

  StudentsModel(
      this.id,
      this.student_name,
      this.profile_image,
      this.year_start,
      this.year_end,
      this.date_created,
      this.class_assigned,
      this.subjects_assigned,
      this.score,
      this.remarks
      );

  factory StudentsModel.fromJson(Map<String, dynamic> json){
    return StudentsModel(
        json['id'],
        json['student_name'],
        json['profile_image'],
        json['year_start'],
        json['year_end'],
        json['date_created'],
        json['class_assigned'],
        json['subjects_assigned'],
        json['score'],
        json['remarks']
    );
  }
}