import 'package:flutter_test/flutter_test.dart';
import 'package:taller3_flutter/features/agenda/data/task_model.dart';

void main() {
  test('TaskModel parses API JSON and serializes task fields', () {
    final task = TaskModel.fromJson({
      '_id': 'task-123',
      'title': 'Entregar taller',
      'description': 'Revisar la agenda',
      'status': 'pending',
      'dueDate': '2026-09-27T00:00:00.000Z',
    });

    expect(task.id, 'task-123');
    expect(task.isCompleted, isFalse);
    expect(task.toJson(), {
      'title': 'Entregar taller',
      'description': 'Revisar la agenda',
      'dueDate': '2026-09-27T00:00:00.000Z',
      'status': 'pending',
    });
  });
}
