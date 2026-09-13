import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../widgets/app_logo.dart';
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

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE53935);
      case 'Medium':
        return const Color(0xFFF59E0B);
      case 'Low':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityBg(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFFEBEE);
      case 'Medium':
        return const Color(0xFFFEF3C7);
      case 'Low':
        return const Color(0xFFE0F2F1);
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Research':
        return const Color(0xFF6366F1);
      case 'Lecture':
        return const Color(0xFF3B82F6);
      case 'Exam':
        return const Color(0xFFEF4444);
      case 'Assignment':
        return const Color(0xFF0D9488);
      case 'Personal':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Research':
        return Icons.biotech_outlined;
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

  List<Task> _getProcessedTasks() {
    var list = List<Task>.from(widget.controller.tasks);

    // Status filter
    if (_statusFilter == 'Pending') {
      list = list.where((t) => !t.completed).toList();
    } else if (_statusFilter == 'Completed') {
      list = list.where((t) => t.completed).toList();
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
        if (a.completed != b.completed) {
          return a.completed ? 1 : -1;
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

  void _confirmDelete(Task task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
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
              widget.controller.removeTask(task);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Task "${task.title}" deleted'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
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

              // Tasks List
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: processedTasks.length,
                        itemBuilder: (context, index) {
                          final task = processedTasks[index];
                          final isDone = task.completed;
                          final priorityColor = _getPriorityColor(task.priority);
                          final priorityBg = _getPriorityBg(task.priority);
                          final categoryColor =
                              _getCategoryColor(task.category);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDone
                                    ? Colors.grey.shade200
                                    : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: isDone
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.02),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
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
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Complete checkbox
                                    InkWell(
                                      onTap: () {
                                        widget.controller
                                            .toggleTaskObjectCompletion(task);
                                      },
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        margin: const EdgeInsets.only(top: 2),
                                        decoration: BoxDecoration(
                                          color: isDone
                                              ? const Color(0xFF0D9488)
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isDone
                                                ? const Color(0xFF0D9488)
                                                : Colors.grey.shade400,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: isDone
                                            ? const Icon(Icons.check_rounded,
                                                size: 15, color: Colors.white)
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Content
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Badges row
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: [
                                              // Category
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: categoryColor
                                                      .withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                        _getCategoryIcon(
                                                            task.category),
                                                        size: 11,
                                                        color: categoryColor),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      task.category,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: categoryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Priority
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: priorityBg,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(Icons.flag_rounded,
                                                        size: 11,
                                                        color: priorityColor),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      task.priority,
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: priorityColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Course badge
                                              if (task.course != null)
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 7,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFEEF2FF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    task.course!,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Color(0xFF4338CA),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const SizedBox(height: 6),

                                          // Title
                                          Text(
                                            task.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              decoration: isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: isDone
                                                  ? Colors.grey.shade500
                                                  : const Color(0xFF0F172A),
                                            ),
                                          ),

                                          if (task.description != null) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              task.description!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: isDone
                                                    ? Colors.grey.shade400
                                                    : const Color(0xFF64748B),
                                              ),
                                            ),
                                          ],

                                          const SizedBox(height: 8),

                                          // Footer info
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: 6,
                                            runSpacing: 2,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    isDone
                                                        ? Icons
                                                            .check_circle_outline
                                                        : Icons
                                                            .access_time_rounded,
                                                    size: 12,
                                                    color: isDone
                                                        ? const Color(0xFF0D9488)
                                                        : Colors.grey.shade600,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    task.deadline ?? 'Upcoming',
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: isDone
                                                          ? const Color(
                                                              0xFF0D9488)
                                                          : Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (task.milestones.isNotEmpty) ...[
                                                Text('•',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade400)),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons.alt_route_rounded,
                                                        size: 11,
                                                        color:
                                                            Color(0xFF4338CA)),
                                                    const SizedBox(width: 3),
                                                    Text(
                                                      '${task.milestones.where((m) => m.completed).length}/${task.milestones.length} milestones',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF4338CA),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Trailing delete icon
                                    IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                          color: Color(0xFFE53935)),
                                      tooltip: 'Delete',
                                      onPressed: () => _confirmDelete(task),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3730A3),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskPage(controller: widget.controller),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFF4F46E5),
        unselectedItemColor: Colors.grey.shade500,
        backgroundColor: Colors.white,
        elevation: 8,
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: 'Add Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Tasks',
          ),
        ],
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
