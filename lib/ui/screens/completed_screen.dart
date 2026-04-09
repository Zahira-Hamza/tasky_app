import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Tasks')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final completed = state.tasks.where((t) => t.isCompleted).toList();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: completed.length,
              itemBuilder: (context, index) {
                final t = completed[index];
                return ListTile(
                  leading: Checkbox(
                    value: t.isCompleted,
                    onChanged: (val) => context.read<TaskCubit>().updateTask(t.copyWith(isCompleted: false)),
                  ),
                  title: Text(t.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
                  subtitle: Text(t.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => context.read<TaskCubit>().deleteTask(t.id),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
