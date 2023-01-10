class Country {
  int? id;
  String? name;
  String? short;
  String? code;

  Country(
      this.id,
      this.name,
      this.short,
      this.code);

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
          json['id'],
          json['name'],
          json['short'],
          json['code']
         );
  }


}
