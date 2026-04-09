import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To Do Tasks')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final uncompleted = state.tasks.where((t) => !t.isCompleted).toList();
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: uncompleted.length,
              itemBuilder: (context, index) {
                final t = uncompleted[index];
                return ListTile(
                  leading: Checkbox(
                    value: t.isCompleted,
                    onChanged: (val) => context.read<TaskCubit>().updateTask(t.copyWith(isCompleted: true)),
                  ),
                  title: Text(t.title),
                  subtitle: Text(t.description),
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
