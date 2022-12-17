
class SubjectsModel{
  var id;
  var subject;
  var date_created;

  SubjectsModel(
      this.id,
      this.subject,
      this.date_created
      );

  factory SubjectsModel.fromJson(Map<String, dynamic> json){
    return SubjectsModel(
        json['id'],
        json['subject'],
        json['date_created']
    );
  }
}