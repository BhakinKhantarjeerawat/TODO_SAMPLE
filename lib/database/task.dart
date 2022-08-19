class Task {
  final String? id;
  final String name;
  final String status;
  final String desc;
  final String date;
  Task({this.id, required this.name, required this.status, required this.desc, required this.date});

  factory Task.fromMap(Map<String, dynamic> json) => new Task(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      desc: json['desc'],
      date: json['date']
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'desc':desc,
      'date':date
    };
  }
}