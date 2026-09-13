import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskController extends ChangeNotifier {
  final List<Task> _tasks = [];
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _firestoreSubscription;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;

  int get totalTasks => _tasks.length;
  int get completedCount => _tasks.where((t) => t.completed == true).length;
  int get pendingCount => _tasks.where((t) => t.completed != true).length;

  TaskController({bool autoSyncFirestore = true}) {
    if (autoSyncFirestore) {
      _initFirestore();
    }
  }

  void _initFirestore() {
    try {
      if (Firebase.apps.isEmpty) {
        return;
      }
      _isLoading = true;
      notifyListeners();

      _firestoreSubscription = FirebaseFirestore.instance
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          _tasks.clear();
          for (final doc in snapshot.docs) {
            try {
              final task = Task.fromMap(doc.data(), doc.id);
              _tasks.add(task);
            } catch (e) {
              debugPrint('Error parsing task doc ${doc.id}: $e');
            }
          }
          _isLoading = false;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Firestore tasks stream error: $error');
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('Firestore init bypassed (offline or test environment): $e');
      _isLoading = false;
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.insert(0, task);
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.id)
            .set(task.toMap());
      }
    } catch (e) {
      debugPrint('Error saving task to Firestore: $e');
    }
  }

  Future<void> insertTaskAt(int index, Task task) async {
    if (index >= 0 && index <= _tasks.length) {
      _tasks.insert(index, task);
    } else {
      _tasks.add(task);
    }
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.id)
            .set(task.toMap());
      }
    } catch (e) {
      debugPrint('Error restoring task to Firestore: $e');
    }
  }

  Future<void> removeTask(Task task) async {
    _tasks.removeWhere((t) => t.id == task.id);
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(task.id)
            .delete();
      }
    } catch (e) {
      debugPrint('Error deleting task from Firestore: $e');
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      removeTask(_tasks[index]);
    }
  }

  Future<void> toggleTaskObjectCompletion(Task task) async {
    final target = _tasks.firstWhere(
      (t) => t.id == task.id,
      orElse: () => task,
    );
    target.completed = !(target.completed == true);
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(target.id)
            .update({'completed': target.completed});
      }
    } catch (e) {
      debugPrint('Error toggling task completion in Firestore: $e');
    }
  }

  void toggleTaskCompletion(int index) {
    if (index >= 0 && index < _tasks.length) {
      toggleTaskObjectCompletion(_tasks[index]);
    }
  }

  Future<void> toggleMilestone(Task task, int milestoneIndex) async {
    final target = _tasks.firstWhere(
      (t) => t.id == task.id,
      orElse: () => task,
    );

    if (milestoneIndex >= 0 && milestoneIndex < target.milestones.length) {
      target.milestones[milestoneIndex].completed =
          !(target.milestones[milestoneIndex].completed == true);
      notifyListeners();

      try {
        if (Firebase.apps.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('tasks')
              .doc(target.id)
              .update({
            'milestones': target.milestones.map((m) => m.toMap()).toList(),
          });
        }
      } catch (e) {
        debugPrint('Error updating milestone in Firestore: $e');
      }
    }
  }

  Future<void> addMilestone(Task task, String milestoneTitle) async {
    if (milestoneTitle.trim().isEmpty) return;

    final target = _tasks.firstWhere(
      (t) => t.id == task.id,
      orElse: () => task,
    );

    target.milestones.add(TaskMilestone(title: milestoneTitle.trim()));
    notifyListeners();

    try {
      if (Firebase.apps.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .doc(target.id)
            .update({
          'milestones': target.milestones.map((m) => m.toMap()).toList(),
        });
      }
    } catch (e) {
      debugPrint('Error adding milestone to Firestore: $e');
    }
  }

  void sortByUrgency() {
    final priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
    _tasks.sort((a, b) {
      final aDone = a.completed == true;
      final bDone = b.completed == true;
      if (aDone != bDone) {
        return aDone ? 1 : -1;
      }
      final pa = priorityOrder[a.priority] ?? 3;
      final pb = priorityOrder[b.priority] ?? 3;
      return pa.compareTo(pb);
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
