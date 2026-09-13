import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/app_logo.dart';
import '../widgets/modern_nav_bar.dart';
import '../widgets/task_card.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class TasksPage extends StatefulWidget {
  final TaskController controller;

  const TasksPage({super.key, required this.controller});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = 'All'; // 'All', 'Pending', 'Completed'
  String _categoryFilter = 'All'; // 'All', or category name
  String _sortBy = 'Urgency'; // 'Urgency', 'Title', 'Course'

  final List<String> _categories = [
    'All',
    'Assignment',
    'Lecture',
    'Research',
    'Exam',
    'Personal',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Task> _getProcessedTasks() {
    var list = List<Task>.from(widget.controller.tasks);

    // Status filter
    if (_statusFilter == 'Pending') {
      list = list.where((t) => t.completed != true).toList();
    } else if (_statusFilter == 'Completed') {
      list = list.where((t) => t.completed == true).toList();
    }

    // Category filter
    if (_categoryFilter != 'All') {
      list = list.where((t) => t.category == _categoryFilter).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      list = list.where((t) {
        final title = t.title.toLowerCase();
        final cat = t.category.toLowerCase();
        final course = (t.course ?? '').toLowerCase();
        final desc = (t.description ?? '').toLowerCase();
        return title.contains(_searchQuery) ||
            cat.contains(_searchQuery) ||
            course.contains(_searchQuery) ||
            desc.contains(_searchQuery);
      }).toList();
    }

    // Sorting
    if (_sortBy == 'Urgency') {
      final order = {'High': 0, 'Medium': 1, 'Low': 2};
      list.sort((a, b) {
        final aDone = a.completed == true;
        final bDone = b.completed == true;
        if (aDone != bDone) {
          return aDone ? 1 : -1;
        }
        final pa = order[a.priority] ?? 3;
        final pb = order[b.priority] ?? 3;
        return pa.compareTo(pb);
      });
    } else if (_sortBy == 'Title') {
      list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } else if (_sortBy == 'Course') {
      list.sort((a, b) =>
          (a.course ?? '').toLowerCase().compareTo((b.course ?? '').toLowerCase()));
    }

    return list;
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
              'Tasks List',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, color: Color(0xFF4F46E5)),
            tooltip: 'Add Task',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskPage(controller: widget.controller),
                ),
              );
            },
          ),
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
          final processedTasks = _getProcessedTasks();
          final total = widget.controller.totalTasks;
          final pending = widget.controller.pendingCount;
          final done = widget.controller.completedCount;

          return Column(
            children: [
              // Search & Filter header container
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    // Search box
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search tasks, courses, or categories...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF4F46E5), size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () => _searchController.clear(),
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        filled: true,
                        fillColor: const Color(0xFFF8F9FE),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Color(0xFF4F46E5), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Filter Pills row & Sort dropdown
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildStatusPill('All', 'All ($total)'),
                                const SizedBox(width: 6),
                                _buildStatusPill('Pending', 'Pending ($pending)'),
                                const SizedBox(width: 6),
                                _buildStatusPill('Completed', 'Done ($done)'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Sort dropdown menu
                        PopupMenuButton<String>(
                          initialValue: _sortBy,
                          tooltip: 'Sort tasks',
                          onSelected: (val) {
                            setState(() {
                              _sortBy = val;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.sort_rounded,
                                    size: 15, color: Color(0xFF4338CA)),
                                const SizedBox(width: 4),
                                Text(
                                  _sortBy,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4338CA),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    size: 16, color: Color(0xFF4338CA)),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'Urgency',
                              child: Text('Sort by Urgency'),
                            ),
                            const PopupMenuItem(
                              value: 'Title',
                              child: Text('Sort by Title'),
                            ),
                            const PopupMenuItem(
                              value: 'Course',
                              child: Text('Sort by Course'),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Category chips row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          final isSelected = _categoryFilter == cat;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ChoiceChip(
                              label: Text(cat),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF475569),
                              ),
                              selected: isSelected,
                              selectedColor: const Color(0xFF4F46E5),
                              backgroundColor: const Color(0xFFF1F5F9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: isSelected
                                      ? const Color(0xFF4F46E5)
                                      : Colors.transparent,
                                ),
                              ),
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _categoryFilter = cat;
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFECEFF1)),

              // Tasks List with Swipe to dismiss / complete
              Expanded(
                child: processedTasks.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'No matching tasks found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'Try searching with a different term'
                                    : 'Change your filters or add a new task',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddTaskPage(
                                          controller: widget.controller),
                                    ),
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF4F46E5),
                                ),
                                icon: const Icon(Icons.add, size: 16),
                                label: const Text('Add Task'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                        itemCount: processedTasks.length,
                        itemBuilder: (context, index) {
                          final task = processedTasks[index];
                          final isDone = task.completed == true;

                          return Dismissible(
                            key: ValueKey('task_page_${task.title}_${task.deadline}_$index'),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D9488),
                                borderRadius: BorderRadius.circular(14),
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
                            secondaryBackground: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE53935),
                                borderRadius: BorderRadius.circular(14),
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
                                widget.controller.toggleTaskObjectCompletion(task);
                                return false;
                              } else {
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TaskDetailPage(
                                      task: task,
                                      controller: widget.controller,
                                    ),
                                  ),
                                );
                              },
                              onToggleComplete: () {
                                widget.controller
                                    .toggleTaskObjectCompletion(task);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ModernNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => AddTaskPage(controller: widget.controller),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusPill(String key, String label) {
    final isSelected = _statusFilter == key;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        setState(() {
          _statusFilter = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3730A3) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
