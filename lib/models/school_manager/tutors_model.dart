
class TutorsModel{
  var id;
  var profile_image;
  var tutor_name;
  var member_category;
  var subjects;
  var date_created;
  var class_assigned;
  var subjects_assigned;
  var phone;
  var whatsapp;

  TutorsModel(
      this.id,
      this.profile_image,
      this.tutor_name,
      this.member_category,
      this.subjects,
      this.date_created,
      this.class_assigned,
      this.subjects_assigned,
      this.phone,
      this.whatsapp
      );

  factory TutorsModel.fromJson(Map<String, dynamic> json){
    return TutorsModel(
      json['id'],
      json['profile_image'],
      json['tutor_name'],
      json['member_category'],
      json['subjects'],
      json['date_created'],
      json['class_assigned'],
      json['subjects_assigned'],
      json['phone'],
      json['whatsapp']
    );
  }
}