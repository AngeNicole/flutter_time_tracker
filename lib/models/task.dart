class Task {
  final String id;
  final String name;
  final String projectId;
  final String description;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.name,
    required this.projectId,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'projectId': projectId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      projectId: json['projectId'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
