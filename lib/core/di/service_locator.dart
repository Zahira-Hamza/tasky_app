import 'package:get_it/get_it.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../logic/task_cubit/task_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Avoid re-registering on hot restart
  if (sl.isRegistered<TaskRepository>()) return;

  final taskRepository = TaskRepository();
  await taskRepository.init();

  final userRepository = UserRepository();

  sl.registerSingleton<TaskRepository>(taskRepository);
  sl.registerSingleton<UserRepository>(userRepository);
  sl.registerFactory<TaskCubit>(() => TaskCubit(sl()));
}
