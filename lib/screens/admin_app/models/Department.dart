class Department {
  final String id;
  final String name;

  Department({this.id, this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Department(
      id: json['_id'],
      name: json['name'],
    );
  }
}
