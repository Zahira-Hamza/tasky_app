import 'package:get_it/get_it.dart';
import '../../data/repositories/task_repository.dart';
import '../../logic/task_cubit/task_cubit.dart';
import '../../logic/theme_cubit/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  final taskRepository = TaskRepository();
  await taskRepository.init();
  
  sl.registerSingleton<TaskRepository>(taskRepository);
  sl.registerFactory<TaskCubit>(() => TaskCubit(sl()));
  sl.registerFactory<ThemeCubit>(() => ThemeCubit());
}
