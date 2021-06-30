class Division {
  final String id;
  final String name;
  final String dep_name;
  final String dir_name;

  Division({this.id, this.name, this.dep_name, this.dir_name});

  factory Division.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Division(
      id: json['_id'],
      name: json['name'],
      dep_name: json['dep_name'],
      dir_name: json['dir_name'],
    );
  }
}
