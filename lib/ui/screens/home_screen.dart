import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/task_cubit/task_state.dart';
import 'new_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Good Evening, Usama'),
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final achieved = state.achievedTasks.length;
            final total = state.tasks.length;
            final percent = total > 0 ? achieved / total : 0.0;
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Yuhuu, Your work Is\nalmost done ! \u{1f44b}', 
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Achieved Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text('$achieved Out of $total Done', style: const TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                              CircularProgressIndicator(
                                value: percent, 
                                backgroundColor: Colors.grey.shade800,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('High Priority Tasks', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (state.highPriorityTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No high priority tasks!', style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.highPriorityTasks.length,
                            itemBuilder: (context, index) {
                              final t = state.highPriorityTasks[index];
                              return ListTile(
                                leading: const Icon(Icons.circle_outlined),
                                title: Text(t.title),
                                onTap: () => context.read<TaskCubit>().updateTask(t.copyWith(isCompleted: true)),
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        const Text('My Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (state.myTasks.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('No tasks available!', style: TextStyle(color: Colors.grey)),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.myTasks.length,
                            itemBuilder: (context, index) {
                              final t = state.myTasks[index];
                              return ListTile(
                                leading: const Icon(Icons.circle_outlined),
                                title: Text(t.title),
                                onTap: () => context.read<TaskCubit>().updateTask(t.copyWith(isCompleted: true)),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                );
              }
            );
          }
          if (state is TaskError) {
             return Center(child: Text("Error: ${state.message}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NewTaskScreen())),
        label: const Text('Add New Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
