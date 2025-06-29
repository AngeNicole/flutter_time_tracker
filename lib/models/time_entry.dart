class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final Duration duration;
  final DateTime date;
  final String notes;
  final DateTime createdAt;

  TimeEntry({
    required this.id,
    required this.projectId,
    required this.taskId,
    required this.duration,
    required this.date,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'taskId': taskId,
      'duration': duration.inMinutes,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory TimeEntry.fromJson(Map<String, dynamic> json) {
    return TimeEntry(
      id: json['id'],
      projectId: json['projectId'],
      taskId: json['taskId'],
      duration: Duration(minutes: json['duration']),
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
