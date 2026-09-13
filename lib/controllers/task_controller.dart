import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  final List<Task> tasks = [
    Task(
      title: 'Research Paper',
      category: 'Research',
      priority: 'High',
      completed: false,
      course: 'CS 490 • SENIOR CAPSTONE',
      description: 'Distributed consensus protocols analysis & benchmark',
      deadline: 'Tomorrow • 11:59 PM',
      duration: '4 hrs',
      extraInfo: '3 PDFs',
      milestones: [
        TaskMilestone(title: 'Download reference papers', completed: true),
        TaskMilestone(title: 'Draft methodology section', completed: false),
        TaskMilestone(title: 'Cite university library sources', completed: false),
      ],
    ),
    Task(
      title: 'Distributed Systems Lecture',
      category: 'Lecture',
      priority: 'Medium',
      completed: false,
      course: 'CS 301 - OS',
      description: 'Live review on Paxos & Raft state machine replication',
      deadline: 'Friday • 10:00 AM',
      duration: '2 hrs',
      extraInfo: 'Hall 302',
      milestones: [
        TaskMilestone(title: 'Review lecture slides', completed: true),
        TaskMilestone(title: 'Take notes on consensus', completed: false),
      ],
    ),
    Task(
      title: 'Algorithms Exam Prep',
      category: 'Exam',
      priority: 'High',
      completed: false,
      course: 'CS 204 - Algorithms',
      description: 'Graph traversals, Dynamic Programming & Bellman-Ford',
      deadline: 'Due Sunday • Final Term',
      duration: '3 hrs',
      extraInfo: 'SI, LK',
      milestones: [
        TaskMilestone(title: 'Solve graph problems', completed: false),
        TaskMilestone(title: 'Review dynamic programming', completed: false),
      ],
    ),
    Task(
      title: 'Submit Physics Lab Report',
      category: 'Assignment',
      priority: 'Medium',
      completed: true,
      course: 'PHYS 102',
      description: 'Electromagnetic wave interference experiments',
      deadline: 'Turned in Today 8:30 AM',
      duration: '2 hrs',
      extraInfo: 'Grade: A',
      milestones: [
        TaskMilestone(title: 'Complete data tables', completed: true),
        TaskMilestone(title: 'Plot interference charts', completed: true),
      ],
    ),
    Task(
      title: 'Buy Calculus Textbook',
      category: 'Personal',
      priority: 'Low',
      completed: true,
      course: 'MATH 101',
      description: 'James Stewart 9th Edition at campus bookstore',
      deadline: 'Completed Yesterday',
      duration: '30 mins',
      extraInfo: 'Campus bookstore',
      milestones: [
        TaskMilestone(title: 'Check student union bookstore', completed: true),
      ],
    ),
  ];

  int get totalTasks => tasks.length;
  int get completedCount => tasks.where((t) => t.completed).length;
  int get pendingCount => tasks.where((t) => !t.completed).length;

  void addTask(Task task) {
    tasks.insert(0, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      notifyListeners();
    }
  }

  void removeTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].completed = !tasks[index].completed;
      notifyListeners();
    }
  }

  void toggleTaskObjectCompletion(Task task) {
    task.completed = !task.completed;
    notifyListeners();
  }

  void toggleMilestone(Task task, int milestoneIndex) {
    if (milestoneIndex >= 0 && milestoneIndex < task.milestones.length) {
      task.milestones[milestoneIndex].completed =
          !task.milestones[milestoneIndex].completed;
      notifyListeners();
    }
  }

  void sortByUrgency() {
    // High > Medium > Low
    final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
    tasks.sort((a, b) {
      if (a.completed != b.completed) {
        return a.completed ? 1 : -1;
      }
      final pa = priorityOrder[a.priority] ?? 3;
      final pb = priorityOrder[b.priority] ?? 3;
      return pa.compareTo(pb);
    });
    notifyListeners();
  }
}
