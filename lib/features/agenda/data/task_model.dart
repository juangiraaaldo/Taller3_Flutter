class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.dueDate,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime? dueDate;

  bool get isCompleted => status == 'completed';

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    final date = json['dueDate'];
    return TaskModel(
      id: (json['id'] ?? json['_id']).toString(),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      dueDate: date == null ? null : DateTime.tryParse(date.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'dueDate': dueDate?.toUtc().toIso8601String(),
    'status': status,
  };
}
