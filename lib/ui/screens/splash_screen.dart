import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/di/service_locator.dart';
import '../../logic/theme_cubit/theme_cubit.dart';
import '../../logic/task_cubit/task_cubit.dart';
import 'onboarding_screen.dart';
import 'root_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Artificial delay for robust splash visibility
    await Future.delayed(const Duration(milliseconds: 600)); 
    
    // Core Dependencies & DB Init
    await Hive.initFlutter();
    await setupLocator();
    
    if (!mounted) return;
    
    // Load persisted theme and fetch initial tasks securely
    await context.read<ThemeCubit>().loadTheme();
    context.read<TaskCubit>().loadTasks();

    final settingsBox = await Hive.openBox('settingsBox');
    final isOnboarded = settingsBox.get('isOnboarded', defaultValue: false) as bool;

    if (!mounted) return;

    if (isOnboarded) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RootScreen()));
    } else {
      await settingsBox.put('isOnboarded', true);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OnboardingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14C67C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 100, color: Colors.white),
            const SizedBox(height: 16),
            const Text(
              'Tasky',
              style: TextStyle(
                fontSize: 32, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
            ),
            const SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white.withOpacity(0.8)),
          ],
        ),
      ),
    );
  }
}
