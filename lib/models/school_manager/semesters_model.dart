
class SemestersModel{
  var id;
  var semester;
  var date_created;

  SemestersModel(
      this.id,
      this.semester,
      this.date_created
      );

  factory SemestersModel.fromJson(Map<String, dynamic> json){
    return SemestersModel(
        json['id'],
        json['semester'],
        json['date_created']
    );
  }
}