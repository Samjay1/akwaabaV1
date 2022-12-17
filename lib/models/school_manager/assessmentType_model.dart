
class AssessmentTypeModel{
  var id;
  var assessment_type;
  var date_created;

  AssessmentTypeModel(
      this.id,
      this.assessment_type,
      this.date_created
      );

  factory AssessmentTypeModel.fromJson(Map<String, dynamic> json){
    return AssessmentTypeModel(
        json['id'],
        json['assessment_type'],
        json['date_created']
    );
  }
}