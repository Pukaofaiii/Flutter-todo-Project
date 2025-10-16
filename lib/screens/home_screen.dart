import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../api/pocketbase_api.dart';
import '../widgets/task_list_item.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

/// Home Screen
/// หน้าจอหลักของแอป แสดงรายการ Tasks ทั้งหมด
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PocketBaseAPI _api = PocketBaseAPI();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// โหลดรายการ Tasks จาก PocketBase
  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tasks = await _api.getTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาด: $e';
        _isLoading = false;
      });
    }
  }

  /// Toggle สถานะของ Task (เสร็จ/ยังไม่เสร็จ)
  Future<void> _toggleTaskStatus(Task task) async {
    try {
      await _api.toggleTaskStatus(task.id, !task.isCompleted);
      // Reload tasks เพื่ออัปเดต UI
      _loadTasks();
    } catch (e) {
      _showErrorSnackBar('ไม่สามารถอัปเดตสถานะได้: $e');
    }
  }

  /// ลบ Task
  Future<void> _deleteTask(Task task) async {
    try {
      await _api.deleteTask(task.id);
      _showSuccessSnackBar('ลบงาน "${task.title}" เรียบร้อยแล้ว');
      // Reload tasks เพื่ออัปเดต UI
      _loadTasks();
    } catch (e) {
      _showErrorSnackBar('ไม่สามารถลบงานได้: $e');
    }
  }

  /// ไปหน้าเพิ่ม Task ใหม่
  Future<void> _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    // ถ้าเพิ่มสำเร็จ (result = true) ให้ reload
    if (result == true) {
      _loadTasks();
    }
  }

  /// ไปหน้าแก้ไข Task
  Future<void> _navigateToEditTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    );

    // ถ้าแก้ไขสำเร็จ (result = true) ให้ reload
    if (result == true) {
      _loadTasks();
    }
  }

  /// แสดง SnackBar เมื่อสำเร็จ
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// แสดง SnackBar เมื่อเกิดข้อผิดพลาด
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.error_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar.large(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: theme.colorScheme.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Tasks',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              // Statistics badge
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_tasks.where((t) => t.isCompleted).length}/${_tasks.length}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                onPressed: _loadTasks,
                tooltip: 'โหลดใหม่',
              ),
              const SizedBox(width: 8),
            ],
          ),
          // Body content
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTask,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New Task',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        tooltip: 'เพิ่มงานใหม่',
      ),
    );
  }

  /// สร้าง Body ของหน้าจอตามสถานะต่างๆ
  Widget _buildBody() {
    final theme = Theme.of(context);

    // กำลังโหลด
    if (_isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading tasks...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // เกิด Error
    if (_errorMessage != null) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 60,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadTasks,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // ไม่มี Tasks
    if (_tasks.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E3A8A).withOpacity(0.1),
                    const Color(0xFF2563EB).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                size: 80,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Tasks Yet',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding your first task\nTap the button below to get started',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    // แสดง ListView ของ Tasks
    return RefreshIndicator(
      onRefresh: _loadTasks,
      color: theme.colorScheme.primary,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _tasks.length,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 8,
          bottom: 100,
        ),
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: TaskListItem(
              task: task,
              onTap: () => _navigateToEditTask(task),
              onCheckboxChanged: (value) => _toggleTaskStatus(task),
              onDelete: () => _deleteTask(task),
            ),
          );
        },
      ),
    );
  }
}
