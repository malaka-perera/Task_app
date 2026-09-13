import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_app/controllers/task_controller.dart';
import 'package:task_app/main.dart';
import 'package:task_app/views/task_detail_page.dart';

void main() {
  testWidgets('Renders Dashboard with TaskMate header, metrics, and tasks', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController();
    await tester.pumpWidget(MyApp(controller: controller));
    await tester.pumpAndSettle();

    // Verify header branding
    expect(find.text('TaskMate'), findsOneWidget);
    expect(find.text('FALL SEMESTER'), findsOneWidget);
    expect(find.text('Welcome back, Alex! 👋'), findsOneWidget);

    // Verify metrics
    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('DONE'), findsOneWidget);
    expect(find.text('PENDING'), findsOneWidget);

    // Verify initial academic tasks
    expect(find.text('Research Paper'), findsOneWidget);
    expect(find.text('Distributed Systems Lecture'), findsOneWidget);
  });

  testWidgets('Can navigate to Add Task screen and add a new academic task', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController();
    await tester.pumpWidget(MyApp(controller: controller));
    await tester.pumpAndSettle();

    // Tap Add New Academic Task button
    await tester.tap(find.text('Add New Academic Task'));
    await tester.pumpAndSettle();

    // Verify Add Task page
    expect(find.text('Create Academic Task'), findsOneWidget);

    // Enter title
    await tester.enterText(
      find.byType(TextFormField),
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
  });

  testWidgets('Can navigate to Task Detail page and view milestones', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    final controller = TaskController();
    await tester.pumpWidget(MyApp(controller: controller));
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

    final controller = TaskController();
    await tester.pumpWidget(MyApp(controller: controller));
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
}
