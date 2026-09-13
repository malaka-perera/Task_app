import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/app_logo.dart';
import '../widgets/modern_nav_bar.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';
import 'tasks_page.dart';

class HomePage extends StatefulWidget {
  final TaskController controller;

  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedFilter = 'All'; // 'All', 'Pending', 'Completed'

  List<Task> _getFilteredTasks() {
    final tasks = widget.controller.tasks;
    if (_selectedFilter == 'Pending') {
      return tasks.where((t) => t.completed != true).toList();
    } else if (_selectedFilter == 'Completed') {
      return tasks.where((t) => t.completed == true).toList();
    }
    return tasks;
  }

  void _openAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskPage(controller: widget.controller),
      ),
    );
  }

  void _openTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailPage(
          task: task,
          controller: widget.controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Center(
            child: AppLogo(size: 38, borderRadius: 10),
          ),
        ),
        leadingWidth: 54,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'TaskMate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'FALL SEMESTER',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF4F46E5).withValues(alpha: 0.15),
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
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final total = widget.controller.totalTasks;
          final done = widget.controller.completedCount;
          final pending = widget.controller.pendingCount;
          final donePercent = total > 0 ? (done / total * 100).round() : 0;
          final filteredTasks = _getFilteredTasks();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome banner
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back! 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.school_rounded,
                                  size: 14, color: Colors.indigo.shade600),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'TaskMate • Academic Workspace',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Stack(
                        children: [
                          Icon(Icons.notifications_none_rounded,
                              color: Color(0xFF4338CA), size: 22),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 3.5,
                              backgroundColor: Color(0xFFE53935),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Streak Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCCFBF1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF99F6E4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.bolt_rounded,
                            color: Color(0xFF0D9488), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'STUDY MOMENTUM',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Color(0xFF0F766E),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              done > 0
                                  ? '$done tasks completed this semester'
                                  : 'Start tracking tasks to build your momentum',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF134E4A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE9FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('🎯', style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 4),
                            Text(
                              '$total Tasks',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B21B6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Metrics Row (3 cards)
                Row(
                  children: [
                    // TOTAL
                    Expanded(
                      child: _buildMetricCard(
                        title: 'TOTAL',
                        value: '$total',
                        subtitle: 'Curriculum tasks',
                        icon: Icons.list_alt_rounded,
                        iconColor: const Color(0xFF4F46E5),
                        iconBg: const Color(0xFFEEF2FF),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // DONE
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'DONE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: Color(0xFF0D9488),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCCFBF1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Color(0xFF0D9488),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  '$done',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$donePercent%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: total > 0 ? done / total : 0,
                                minHeight: 4,
                                backgroundColor: const Color(0xFFE2E8F0),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0D9488),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // PENDING
                    Expanded(
                      child: _buildMetricCard(
                        title: 'PENDING',
                        value: '$pending',
                        subtitle: 'Due this week',
                        icon: Icons.access_time_rounded,
                        iconColor: const Color(0xFFF57C00),
                        iconBg: const Color(0xFFFFF3E0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Primary Add New Academic Task Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: _openAddTask,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF3730A3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                    label: const Text(
                      'Add New Academic Task',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Section Header: Today's Tasks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Today's Tasks",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$total',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4338CA),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        widget.controller.sortByUrgency();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sorted by priority urgency'),
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Sort by Urgency',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(Icons.swap_vert_rounded,
                              size: 16, color: Color(0xFF4F46E5)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Filter tabs: All (5), Pending (3), Completed (2)
                Row(
                  children: [
                    _buildFilterChip('All', 'All ($total)'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Pending', 'Pending ($pending)'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed', 'Completed ($done)'),
                  ],
                ),

                const SizedBox(height: 16),

                // Tasks list
                if (filteredTasks.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 36, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF1E1B4B).withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in_outlined,
                            size: 40,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          total == 0
                              ? 'No academic tasks yet!'
                              : 'No ${_selectedFilter.toLowerCase()} tasks',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          total == 0
                              ? 'Organize your semester, lectures, and exams.\nTap below to create your first task.'
                              : 'You have no tasks matching the "$_selectedFilter" filter.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        if (total == 0) ...[
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: _openAddTask,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF4F46E5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text('Add First Task'),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  ...filteredTasks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;
                    final isDone = task.completed == true;

                    return Dismissible(
                      key: ValueKey('${task.title}_${task.deadline}_$index'),
                      direction: DismissDirection.horizontal,
                      // Swipe right -> Toggle complete
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              isDone
                                  ? Icons.replay_rounded
                                  : Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isDone ? 'Mark Pending' : 'Complete',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Swipe left -> Delete
                      secondaryBackground: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE53935),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Toggle completion
                          widget.controller.toggleTaskObjectCompletion(task);
                          return false; // Don't dismiss from list
                        } else {
                          // Delete action
                          final taskIndex =
                              widget.controller.tasks.indexOf(task);
                          widget.controller.removeTask(task);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task "${task.title}" deleted'),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'UNDO',
                                textColor: const Color(0xFFA5B4FC),
                                onPressed: () {
                                  widget.controller
                                      .insertTaskAt(taskIndex, task);
                                },
                              ),
                            ),
                          );
                          return true;
                        }
                      },
                      child: TaskCard(
                        task: task,
                        onTap: () => _openTaskDetail(task),
                        onToggleComplete: () =>
                            widget.controller.toggleTaskObjectCompletion(task),
                      ),
                    );
                  }),

                const SizedBox(height: 10),

                Builder(
                  builder: (context) {
                    final pendingTasks = widget.controller.tasks
                        .where((t) => t.completed != true)
                        .toList();
                    final urgentTask = pendingTasks.isNotEmpty
                        ? pendingTasks.firstWhere(
                            (t) => t.priority == 'High',
                            orElse: () => pendingTasks.first,
                          )
                        : null;

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE9FE),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.local_cafe_outlined,
                              color: Color(0xFF5B21B6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      urgentTask != null
                                          ? 'Recommended Focus Zone'
                                          : 'Semester All Set!',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('🟢',
                                        style: TextStyle(fontSize: 9)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  urgentTask != null
                                      ? 'Recommended for "${urgentTask.title}" (${urgentTask.priority} priority)'
                                      : 'No pending deadlines. Enjoy your study break!',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.arrow_forward_rounded,
                                size: 16, color: Color(0xFF4338CA)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ModernNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            _openAddTask();
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TasksPage(controller: widget.controller),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          _selectedFilter = filterKey;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3730A3) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
