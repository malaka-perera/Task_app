import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
  });

  Color _getCategoryBg(String category) {
    switch (category) {
      case 'Research':
        return const Color(0xFFEEF2FF);
      case 'Lecture':
        return const Color(0xFFE0F2FE);
      case 'Exam':
        return const Color(0xFFFFE4E6);
      case 'Assignment':
        return const Color(0xFFCCFBF1);
      case 'Personal':
        return const Color(0xFFF3E8FF);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Research':
        return const Color(0xFF4F46E5);
      case 'Lecture':
        return const Color(0xFF0284C7);
      case 'Exam':
        return const Color(0xFFE11D48);
      case 'Assignment':
        return const Color(0xFF0D9488);
      case 'Personal':
        return const Color(0xFF7E22CE);
      default:
        return const Color(0xFF475569);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Research':
        return Icons.biotech_rounded;
      case 'Lecture':
        return Icons.laptop_chromebook;
      case 'Exam':
        return Icons.edit_note_rounded;
      case 'Assignment':
        return Icons.description_outlined;
      case 'Personal':
        return Icons.person_outline_rounded;
      default:
        return Icons.bookmark_border_rounded;
    }
  }

  Color _getPriorityBg(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFFE4E6);
      case 'Medium':
        return const Color(0xFFFEF3C7);
      case 'Low':
        return const Color(0xFFE0F2FE);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE11D48);
      case 'Medium':
        return const Color(0xFFD97706);
      case 'Low':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFF475569);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDone = task.completed == true;
    final catBg = _getCategoryBg(task.category);
    final catColor = _getCategoryColor(task.category);
    final priorityBg = _getPriorityBg(task.priority);
    final priorityColor = _getPriorityColor(task.priority);

    // Urgent if High priority and not completed
    final isUrgent = task.priority == 'High' && !isDone;
    final footerColor = isDone
        ? const Color(0xFF0D9488)
        : (isUrgent ? const Color(0xFFE11D48) : const Color(0xFF64748B));

    // Fallback for extra info: if extraInfo is null but milestones exist, show milestone progress
    final displayExtraInfo = task.extraInfo ??
        (task.milestones.isNotEmpty
            ? '${task.milestones.where((m) => m.completed == true).length}/${task.milestones.length} Milestones'
            : null);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone ? const Color(0xFFF1F5F9) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: isDone
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF1E1B4B).withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom Rounded Checkbox matching screenshot exactly
                GestureDetector(
                  key: ValueKey('task_card_checkbox_${task.title}'),
                  onTap: onToggleComplete,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2, right: 14),
                    decoration: BoxDecoration(
                      color: isDone ? const Color(0xFF0D9488) : Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF0D9488)
                            : const Color(0xFFCBD5E1),
                        width: 1.8,
                      ),
                    ),
                    child: isDone
                        ? const Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),

                // Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badges Row matching screenshot exactly: Category, Priority, Status
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          // 1. Category Pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: catBg,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(task.category),
                                  size: 13,
                                  color: catColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: catColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 2. Priority Pill with Flag Icon
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: priorityBg,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  size: 13,
                                  color: priorityColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.priority,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: priorityColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 3. Status Pill (Pending with dot, or Completed with check)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? const Color(0xFFCCFBF1)
                                  : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isDone)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 12,
                                    color: Color(0xFF0D9488),
                                  )
                                else
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFD97706),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                const SizedBox(width: 5),
                                Text(
                                  isDone ? 'Completed' : 'Pending',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isDone
                                        ? const Color(0xFF0D9488)
                                        : const Color(0xFFD97706),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      // Task Title
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDone
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF0F172A),
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                          decorationColor:
                              isDone ? const Color(0xFF94A3B8) : null,
                        ),
                      ),

                      // Task Subtitle / Description
                      if (task.description != null &&
                          task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: isDone
                                ? const Color(0xFFA0AEC0)
                                : const Color(0xFF64748B),
                            decoration:
                                isDone ? TextDecoration.lineThrough : null,
                            decorationColor:
                                isDone ? const Color(0xFFA0AEC0) : null,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Footer Line (Clock Icon + Deadline + Extra Info)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        runSpacing: 2,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: footerColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            task.deadline ?? 'Upcoming',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: (isUrgent || isDone)
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: footerColor,
                            ),
                          ),
                          if (displayExtraInfo != null) ...[
                            const SizedBox(width: 2),
                            const Text(
                              '•',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              displayExtraInfo,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
