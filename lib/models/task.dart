class TaskMilestone {
  final String title;
  bool completed;

  TaskMilestone({
    required this.title,
    this.completed = false,
  });
}

class Task {
  final String title;
  final String category;
  final String priority;
  bool completed;

  final String? description;
  final String? course;
  final String? deadline;
  final String? duration;
  final String? extraInfo;
  final List<TaskMilestone> milestones;

  Task({
    required this.title,
    required this.category,
    required this.priority,
    this.completed = false,
    this.description,
    this.course,
    this.deadline,
    this.duration,
    this.extraInfo,
    List<TaskMilestone>? milestones,
  }) : milestones = milestones ?? [];
}
