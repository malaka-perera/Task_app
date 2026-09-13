class TaskMilestone {
  final String title;
  bool completed;

  TaskMilestone({
    required this.title,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  factory TaskMilestone.fromMap(Map<String, dynamic> map) {
    return TaskMilestone(
      title: map['title'] as String? ?? '',
      completed: map['completed'] as bool? ?? false,
    );
  }
}

class Task {
  final String id;
  final String title;
  final String category;
  final String priority;
  bool completed;

  final String? description;
  final String? course;
  final String? deadline;
  final String? duration;
  final String? extraInfo;
  final List<String> attachments;
  final List<TaskMilestone> milestones;
  final DateTime createdAt;

  Task({
    String? id,
    required this.title,
    required this.category,
    required this.priority,
    this.completed = false,
    this.description,
    this.course,
    this.deadline,
    this.duration,
    this.extraInfo,
    List<String>? attachments,
    List<TaskMilestone>? milestones,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        attachments = attachments ?? [],
        milestones = milestones ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'priority': priority,
      'completed': completed,
      'description': description,
      'course': course,
      'deadline': deadline,
      'duration': duration,
      'extraInfo': extraInfo,
      'attachments': attachments,
      'milestones': milestones.map((m) => m.toMap()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, [String? id]) {
    final rawMilestones = map['milestones'] as List<dynamic>? ?? [];
    final parsedMilestones = rawMilestones
        .map((m) => TaskMilestone.fromMap(Map<String, dynamic>.from(m as Map)))
        .toList();

    final rawAttachments = map['attachments'] as List<dynamic>? ?? [];
    final parsedAttachments =
        rawAttachments.map((a) => a.toString()).toList();

    return Task(
      id: id ?? map['id'] as String?,
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      priority: map['priority'] as String? ?? 'Medium',
      completed: map['completed'] as bool? ?? false,
      description: map['description'] as String?,
      course: map['course'] as String?,
      deadline: map['deadline'] as String?,
      duration: map['duration'] as String?,
      extraInfo: map['extraInfo'] as String?,
      attachments: parsedAttachments,
      milestones: parsedMilestones,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? category,
    String? priority,
    bool? completed,
    String? description,
    String? course,
    String? deadline,
    String? duration,
    String? extraInfo,
    List<String>? attachments,
    List<TaskMilestone>? milestones,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      completed: completed ?? this.completed,
      description: description ?? this.description,
      course: course ?? this.course,
      deadline: deadline ?? this.deadline,
      duration: duration ?? this.duration,
      extraInfo: extraInfo ?? this.extraInfo,
      attachments: attachments ?? List.from(this.attachments),
      milestones: milestones ?? List.from(this.milestones),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
