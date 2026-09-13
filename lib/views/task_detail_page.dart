import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;
  final TaskController controller;

  const TaskDetailPage({
    super.key,
    required this.task,
    required this.controller,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Medium':
        return const Color(0xFFF57C00);
      case 'Low':
        return const Color(0xFF00897B);
      default:
        return Colors.grey.shade700;
    }
  }

  Color _getPriorityBgColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFFEBEE);
      case 'Medium':
        return const Color(0xFFFFF3E0);
      case 'Low':
        return const Color(0xFFE0F2F1);
      default:
        return Colors.grey.shade100;
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Academic Task'),
        content: Text('Are you sure you want to delete "${widget.task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
            ),
            onPressed: () {
              widget.controller.removeTask(widget.task);
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${widget.task.title}" deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAttachmentPreview(
      String filename, String details, IconData icon, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                filename,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 36, color: color),
                  const SizedBox(height: 6),
                  const Text(
                    'Preview Rendered Locally',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading $filename...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.download_rounded, size: 16),
            label: const Text('Download'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final isDone = task.completed == true;
    final priorityColor = _getPriorityColor(task.priority);
    final priorityBg = _getPriorityBgColor(task.priority);

    final completedMilestones =
        task.milestones.where((m) => m.completed == true).length;
    final totalMilestones = task.milestones.length;
    final progress = totalMilestones > 0
        ? completedMilestones / totalMilestones
        : (isDone ? 1.0 : 0.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Detail',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'TASK DETAILS',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF4F46E5),
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  widget.controller.toggleTaskObjectCompletion(task);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
              child: const Text(
                'AP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4338CA),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Urgent & Synced banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        task.priority == 'High'
                            ? 'URGENT DELIVERABLE'
                            : 'STANDARD DELIVERABLE',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.cloud_done_outlined,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        'Synced 4m ago',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFECEFF1)),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPill(
                        icon: Icons.science_outlined,
                        label: task.category,
                        bg: const Color(0xFFEDE9FE),
                        color: const Color(0xFF5B21B6),
                      ),
                      _buildPill(
                        icon: Icons.priority_high_rounded,
                        label: '${task.priority} Priority',
                        bg: priorityBg,
                        color: priorityColor,
                      ),
                      _buildPill(
                        icon: isDone
                            ? Icons.check_circle_rounded
                            : Icons.fiber_manual_record,
                        label: isDone ? 'Completed' : 'Pending',
                        bg: isDone
                            ? const Color(0xFFE0F2F1)
                            : const Color(0xFFFFEBEE),
                        color: isDone
                            ? const Color(0xFF00796B)
                            : const Color(0xFFD32F2F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Course Title
                  Text(
                    task.course ?? 'CS 490 • SENIOR CAPSTONE',
                    style: const TextStyle(
                      fontSize: 13,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4338CA),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Main Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      decoration:
                          isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? Colors.grey : const Color(0xFF1E293B),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Deadline Card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDBEAFE)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF2563EB),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'DEADLINE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                task.deadline ?? 'Tomorrow, Oct 25 • 11:59 PM',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFBE123C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'In 28h',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Requirement & Notes
                  Row(
                    children: [
                      Icon(Icons.description_outlined,
                          size: 15, color: Colors.grey.shade700),
                      const SizedBox(width: 6),
                      const Text(
                        'REQUIREMENT & NOTES',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (task.description != null &&
                            task.description!.trim().isNotEmpty)
                        ? task.description!
                        : 'No additional notes provided for this task.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: (task.description != null &&
                              task.description!.trim().isNotEmpty)
                          ? const Color(0xFF334155)
                          : const Color(0xFF94A3B8),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Attachment cards (Dynamic)
                  if (task.attachments.isNotEmpty)
                    Row(
                      children: task.attachments.map((att) {
                        final isPdf = att.toLowerCase().endsWith('.pdf');
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _showAttachmentPreview(
                                att,
                                isPdf
                                    ? 'Document • Reference Material'
                                    : 'Image • Attached Note',
                                isPdf
                                    ? Icons.picture_as_pdf_rounded
                                    : Icons.image_rounded,
                                isPdf
                                    ? const Color(0xFF4F46E5)
                                    : const Color(0xFFD97706),
                              ),
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    colors: isPdf
                                        ? [
                                            const Color(0xFF1E293B),
                                            const Color(0xFF334155)
                                          ]
                                        : [
                                            const Color(0xFFB45309),
                                            const Color(0xFFD97706)
                                          ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        isPdf
                                            ? Icons.description_outlined
                                            : Icons.image_outlined,
                                        size: 32,
                                        color: Colors.white
                                            .withValues(alpha: 0.3),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 6,
                                      left: 6,
                                      right: 6,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.6),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.attachment,
                                                size: 11, color: Colors.white),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                att,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.attach_file_rounded,
                              size: 16, color: Color(0xFF94A3B8)),
                          SizedBox(width: 8),
                          Text(
                            'No file attachments for this task',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Academic Milestones Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.alt_route_rounded,
                              size: 16, color: Color(0xFF475569)),
                          SizedBox(width: 6),
                          Text(
                            'ACADEMIC MILESTONES',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$completedMilestones/$totalMilestones Completed',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF0D9488),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Milestones checklist
                  ...List.generate(task.milestones.length, (idx) {
                    final m = task.milestones[idx];
                    final mDone = m.completed == true;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: mDone
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: mDone,
                            activeColor: const Color(0xFF0D9488),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (_) {
                              setState(() {
                                widget.controller.toggleMilestone(task, idx);
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              m.title,
                              style: TextStyle(
                                fontSize: 13,
                                decoration: mDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: mDone
                                    ? Colors.grey.shade500
                                    : const Color(0xFF1E293B),
                                fontWeight: mDone
                                    ? FontWeight.normal
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.drag_indicator,
                              size: 18, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                        ],
                      ),
                    );
                  }),

                  if (totalMilestones > 0 && completedMilestones == totalMilestones) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFCCFBF1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.celebration_rounded,
                              size: 18, color: Color(0xFF0F766E)),
                          SizedBox(width: 8),
                          Text(
                            'All academic milestones completed! 🎉',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F766E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Mark as Complete / Incomplete Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          widget.controller.toggleTaskObjectCompletion(task);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(task.completed == true
                                ? 'Task marked as completed'
                                : 'Task marked as pending'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: isDone
                            ? const Color(0xFF475569)
                            : const Color(0xFF0F766E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(isDone
                          ? Icons.replay_rounded
                          : Icons.check_circle_outline_rounded),
                      label: Text(
                        isDone
                            ? 'Mark as Pending'
                            : 'Mark as Complete',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Delete Task Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton.icon(
                      onPressed: _confirmDelete,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFE53935),
                        backgroundColor: const Color(0xFFFFEBEE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text(
                        'Delete Task',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Other Class Tasks Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.list_alt_rounded,
                              size: 18, color: Color(0xFF4338CA)),
                          SizedBox(width: 6),
                          Text(
                            'Other Class Tasks',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${widget.controller.tasks.length - 1} more',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4338CA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...widget.controller.tasks
                      .where((t) => t != task)
                      .take(2)
                      .map((otherTask) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          leading: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(otherTask.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            otherTask.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${otherTask.course ?? "Academic"} • Due ${otherTask.deadline ?? "Soon"}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right, size: 20),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailPage(
                                  task: otherTask,
                                  controller: widget.controller,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPill({
    required IconData icon,
    required String label,
    required Color bg,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
