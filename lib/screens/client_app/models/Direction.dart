class Direction {
  final String id;
  final String name;
  final String dep_name;

  Direction({this.id, this.name, this.dep_name});

  factory Direction.fromJson(Map<String, dynamic> json) {
    print(json.toString());
    return Direction(
      id: json['_id'],
      name: json['name'],
      dep_name: json['dep_name'],
    );
  }
}
