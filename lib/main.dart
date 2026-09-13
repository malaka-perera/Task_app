import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/task_controller.dart';
import 'views/home_page.dart';
import 'views/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TaskController taskController;
  final bool showSplash;

  MyApp({
    super.key,
    TaskController? controller,
    this.showSplash = true,
  }) : taskController = controller ?? TaskController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.light,
        ),
      ),
      home: showSplash
          ? SplashPage(controller: taskController)
          : HomePage(controller: taskController),
    );
  }
}
