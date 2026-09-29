import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/warm_gradient_background.dart';
import '../../../auth/presentation/pages/profile_page.dart';
import '../../data/agenda_api.dart';
import '../../data/task_model.dart';
import '../widgets/task_card.dart';
import 'task_form_page.dart';

class AgendaListPage extends StatefulWidget {
  const AgendaListPage({super.key});

  @override
  State<AgendaListPage> createState() => _AgendaListPageState();
}

class _AgendaListPageState extends State<AgendaListPage> {
  final _agendaApi = AgendaApi();
  late Future<List<TaskModel>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _agendaApi.getTasks();
  }

  Future<void> _refresh() async {
    final request = _agendaApi.getTasks();
    setState(() => _tasks = request);
    try {
      await request;
    } catch (_) {}
  }

  Future<void> _openForm({TaskModel? task}) async {
    final changed = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => TaskFormPage(task: task)));
    if (changed == true && mounted) await _refresh();
  }

  Future<void> _toggleStatus(TaskModel task) async {
    final updated = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      status: task.isCompleted ? 'pending' : 'completed',
    );
    try {
      await _agendaApi.updateTask(updated);
      if (mounted) await _refresh();
    } catch (error) {
      _showError(error);
    }
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: Text('¿Quieres eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _agendaApi.deleteTask(task.id);
      if (mounted) await _refresh();
    } catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString().replaceFirst('Exception: ', ''))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Mi agenda'),
        backgroundColor: AppColors.agendaPink,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
            icon: const Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: WarmGradientBackground(
        child: FutureBuilder<List<TaskModel>>(
          future: _tasks,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _messageState(
                icon: Icons.cloud_off_outlined,
                message: snapshot.error.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
                action: TextButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              );
            }

            final tasks = snapshot.data ?? [];
            if (tasks.isEmpty) {
              return RefreshIndicator(
                onRefresh: _refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 140),
                    Icon(
                      Icons.event_note_outlined,
                      size: 54,
                      color: Colors.black38,
                    ),
                    SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Aún no tienes tareas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 6),
                    Center(
                      child: Text('Crea una tarea para organizar tu agenda.'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onEdit: () => _openForm(task: task),
                    onDelete: () => _deleteTask(task),
                    onToggleStatus: () => _toggleStatus(task),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: AppColors.authPink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }

  Widget _messageState({
    required IconData icon,
    required String message,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Colors.black38),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            ?action,
          ],
        ),
      ),
    );
  }
}
