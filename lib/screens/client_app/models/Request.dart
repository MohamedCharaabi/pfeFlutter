class PersonalRequest {
  final String id;
  final String name;
  final String lastName;
  final String email;
  final String theme;
  final String date;
  final String level;
  final String depName;
  final String dirName;
  final String divName;
  final String serName;
  final List<dynamic> history;

  PersonalRequest(
      {this.id,
      this.name,
      this.lastName,
      this.email,
      this.theme,
      this.date,
      this.level,
      this.depName,
      this.dirName,
      this.divName,
      this.serName,
      this.history});

  factory PersonalRequest.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return PersonalRequest(
      id: json['_id'],
      name: json['nomDem'],
      lastName: json['prenomDem'],
      email: json['emailDem'],
      theme: json['themeDem'],
      date: json['dateDem'],
      level: json['name'],
      depName: json['dep_name'],
      dirName: json['dir_name'],
      divName: json['div_name'],
      serName: json['ser_name'],
      history: json['history'],
    );
  }
}
