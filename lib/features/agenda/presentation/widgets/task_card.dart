import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/task_model.dart';
import 'status_badge.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final dueDate = task.dueDate?.toLocal();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Acciones de tarea',
                  onSelected: (value) {
                    if (value == 'edit') onEdit();
                    if (value == 'delete') onDelete();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                style: const TextStyle(color: Colors.black54),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                StatusBadge(completed: task.isCompleted),
                if (dueDate != null) ...[
                  const SizedBox(width: 10),
                  Icon(Icons.event_outlined, size: 16, color: AppColors.navy),
                  const SizedBox(width: 4),
                  Text(
                    '${dueDate.day.toString().padLeft(2, '0')}/${dueDate.month.toString().padLeft(2, '0')}/${dueDate.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
                const Spacer(),
                TextButton.icon(
                  onPressed: onToggleStatus,
                  icon: Icon(
                    task.isCompleted
                        ? Icons.undo_outlined
                        : Icons.check_circle_outline,
                  ),
                  label: Text(task.isCompleted ? 'Reabrir' : 'Completar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
