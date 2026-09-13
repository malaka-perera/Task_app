import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/controllers/task_controller.dart';
import 'package:task_app/main.dart';
import 'package:task_app/models/task.dart';
import 'package:task_app/views/splash_page.dart';
import 'package:task_app/views/task_detail_page.dart';
import 'package:task_app/widgets/task_card.dart';

void main() {
  testWidgets('Renders SplashPage with logo, branding, and loading status', (
    WidgetTester tester,
  ) async {
    final controller = TaskController(autoSyncFirestore: false);
    await tester.pumpWidget(
      MyApp(controller: controller, showSplash: true),
    );

    // Initial frame of splash
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(SplashPage), findsOneWidget);
    expect(find.text('TaskMate'), findsOneWidget);
    expect(find.text('FALL SEMESTER'), findsOneWidget);
    expect(find.text('Student Academic Task Manager'), findsOneWidget);
    expect(find.text('University Edition • v1.0.0'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Pump past the transition timer to navigate to HomePage
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Welcome back! 👋'), findsOneWidget);
  });

  testWidgets('Renders clean Dashboard with empty state when no tasks exist', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController(autoSyncFirestore: false);
    await tester.pumpWidget(MyApp(controller: controller, showSplash: false));
    await tester.pumpAndSettle();

    // Verify header branding
    expect(find.text('TaskMate'), findsOneWidget);
    expect(find.text('FALL SEMESTER'), findsOneWidget);
    expect(find.text('Welcome back! 👋'), findsOneWidget);

    // Verify metrics
    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('DONE'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);

    // Verify empty state
    expect(find.text('No academic tasks yet!'), findsOneWidget);
    expect(find.text('Add First Task'), findsOneWidget);
    expect(find.text('Semester All Set!'), findsOneWidget);
  });

  testWidgets('Can navigate to Add Task screen and add a new academic task', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController(autoSyncFirestore: false);
    await tester.pumpWidget(MyApp(controller: controller, showSplash: false));
    await tester.pumpAndSettle();

    // Tap Add New Academic Task button
    await tester.tap(find.text('Add New Academic Task'));
    await tester.pumpAndSettle();

    // Verify Add Task page
    expect(find.text('Create Academic Task'), findsOneWidget);

    // Enter title in first TextFormField
    final textFields = find.byType(TextFormField);
    await tester.enterText(
      textFields.first,
      'Complete Operating Systems Assignment',
    );
    await tester.pump();

    // Verify live feedback
    expect(find.text('Valid task title specified'), findsOneWidget);

    // Ensure button is visible and tap Add Task to Schedule
    final submitButton = find.text('Add Task to Schedule');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Verify task is now on Dashboard
    expect(find.text('Complete Operating Systems Assignment'), findsOneWidget);
    expect(find.text('1 Tasks'), findsOneWidget);
  });

  testWidgets('Can navigate to Task Detail page and view milestones', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController(autoSyncFirestore: false);
    await controller.addTask(
      Task(
        title: 'Research Paper',
        category: 'Research',
        priority: 'High',
        completed: false,
        course: 'CS 490 - Senior Capstone',
        description: 'Distributed consensus protocols analysis & benchmark',
        deadline: 'Tomorrow • 11:59 PM',
        milestones: [
          TaskMilestone(title: 'Download reference papers', completed: true),
          TaskMilestone(title: 'Draft methodology section', completed: false),
        ],
      ),
    );

    await tester.pumpWidget(MyApp(controller: controller, showSplash: false));
    await tester.pumpAndSettle();

    // Ensure card is visible and tap on Research Paper
    final taskCard = find.text('Research Paper');
    await tester.ensureVisible(taskCard);
    await tester.tap(taskCard);
    await tester.pumpAndSettle();

    // Verify we are on Task Detail page
    expect(find.byType(TaskDetailPage), findsOneWidget);
    expect(find.text('ACADEMIC MILESTONES'), findsOneWidget);
    expect(find.text('Download reference papers'), findsOneWidget);
    expect(find.text('Mark as Complete'), findsOneWidget);
  });

  testWidgets('Can navigate to dedicated TasksPage and search tasks', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController(autoSyncFirestore: false);
    await controller.addTask(
      Task(
        title: 'Research Paper',
        category: 'Research',
        priority: 'High',
      ),
    );
    await controller.addTask(
      Task(
        title: 'Submit Physics Lab Report',
        category: 'Assignment',
        priority: 'Medium',
      ),
    );

    await tester.pumpWidget(MyApp(controller: controller, showSplash: false));
    await tester.pumpAndSettle();

    // Tap Tasks tab in bottom navigation bar
    final tasksTab = find.text('Tasks');
    await tester.tap(tasksTab);
    await tester.pumpAndSettle();

    // Verify we are on TasksPage
    expect(find.text('Tasks List'), findsOneWidget);
    expect(find.text('Search tasks, courses, or categories...'), findsOneWidget);

    // Initial tasks should be listed
    expect(find.text('Research Paper'), findsOneWidget);

    // Search for "Physics"
    await tester.enterText(find.byType(TextField), 'Physics');
    await tester.pumpAndSettle();

    expect(find.text('Submit Physics Lab Report'), findsOneWidget);
    expect(find.text('Research Paper'), findsNothing);
  });

  testWidgets('Renders TaskCard matching screenshot design specs', (
    WidgetTester tester,
  ) async {
    final pendingTask = Task(
      title: 'Research Paper',
      category: 'Research',
      priority: 'High',
      completed: false,
      description: 'Distributed consensus protocols analysis & benchmark',
      deadline: 'Tomorrow • 11:59 PM',
      extraInfo: '3 PDFs',
    );

    final completedTask = Task(
      title: 'Submit Physics Lab Report',
      category: 'Assignment',
      priority: 'Medium',
      completed: true,
      description: 'Electromagnetic wave interference experiments',
      deadline: 'Turned in Today 8:30 AM',
      extraInfo: 'Grade: A',
    );

    var pendingTapped = false;
    var completedToggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TaskCard(
                task: pendingTask,
                onTap: () => pendingTapped = true,
                onToggleComplete: () {},
              ),
              TaskCard(
                task: completedTask,
                onTap: () {},
                onToggleComplete: () => completedToggled = true,
              ),
            ],
          ),
        ),
      ),
    );

    // Verify Pending card content
    expect(find.text('Research Paper'), findsOneWidget);
    expect(find.text('Research'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(
        find.text('Distributed consensus protocols analysis & benchmark'),
        findsOneWidget);
    expect(find.text('Tomorrow • 11:59 PM'), findsOneWidget);
    expect(find.text('3 PDFs'), findsOneWidget);

    // Verify Completed card content
    expect(find.text('Submit Physics Lab Report'), findsOneWidget);
    expect(find.text('Assignment'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Turned in Today 8:30 AM'), findsOneWidget);
    expect(find.text('Grade: A'), findsOneWidget);

    // Test tap interaction
    await tester.tap(find.text('Research Paper'));
    expect(pendingTapped, isTrue);

    // Test checkbox toggle interaction
    final checkbox = find.byKey(
        const ValueKey('task_card_checkbox_Submit Physics Lab Report'));
    await tester.tap(checkbox);
    expect(completedToggled, isTrue);
  });
}
