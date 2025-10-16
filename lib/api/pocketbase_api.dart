import 'package:pocketbase/pocketbase.dart';
import '../models/task_model.dart';

/// PocketBase API Service
/// จัดการการเชื่อมต่อและ CRUD operations กับ PocketBase Backend
class PocketBaseAPI {
  // Singleton pattern - ให้มี instance เดียวในแอป
  static final PocketBaseAPI _instance = PocketBaseAPI._internal();
  factory PocketBaseAPI() => _instance;
  PocketBaseAPI._internal();

  // PocketBase client instance
  late PocketBase pb;

  // ชื่อ collection ใน PocketBase (ต้องสร้างใน PocketBase Admin ก่อน)
  static const String collectionName = 'tasks';

  /// เชื่อมต่อกับ PocketBase Server
  ///
  /// **สำคัญ**: ต้องเปลี่ยน URL ตามที่ PocketBase ของคุณรันอยู่
  /// - Local development: http://127.0.0.1:8090
  /// - Production: https://your-domain.com
  void initialize(String url) {
    pb = PocketBase(url);
  }

  /// ดึงรายการ Tasks ทั้งหมดจาก PocketBase
  ///
  /// Returns: List<Task> - รายการงานทั้งหมด
  Future<List<Task>> getTasks() async {
    try {
      // ดึงข้อมูลจาก collection 'tasks' โดยเรียงจากล่าสุดไปเก่าสุด
      final records = await pb.collection(collectionName).getFullList(
        sort: '-created', // เรียงจากล่าสุดก่อน (- = descending)
      );

      // แปลง JSON เป็น Task objects
      return records.map((record) => Task.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      rethrow; // โยน error ออกไปให้ UI จัดการ
    }
  }

  /// สร้าง Task ใหม่
  ///
  /// Parameters:
  /// - title: ชื่องาน
  ///
  /// Returns: Task object ที่สร้างเสร็จแล้ว (มี id จาก PocketBase)
  Future<Task> createTask(String title) async {
    try {
      final body = {
        'title': title,
        'is_completed': false, // สถานะเริ่มต้น
      };

      final record = await pb.collection(collectionName).create(body: body);
      return Task.fromJson(record.toJson());
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  /// อัปเดต Task ที่มีอยู่
  ///
  /// Parameters:
  /// - id: ID ของ Task ที่ต้องการอัปเดต
  /// - title: ชื่องานใหม่
  /// - isCompleted: สถานะใหม่
  ///
  /// Returns: Task object ที่อัปเดตแล้ว
  Future<Task> updateTask({
    required String id,
    String? title,
    bool? isCompleted,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (isCompleted != null) body['is_completed'] = isCompleted;

      final record = await pb.collection(collectionName).update(id, body: body);
      return Task.fromJson(record.toJson());
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }

  /// เปลี่ยนสถานะ Task (toggle completed/incomplete)
  ///
  /// Parameters:
  /// - id: ID ของ Task
  /// - isCompleted: สถานะใหม่
  ///
  /// Returns: Task object ที่อัปเดตแล้ว
  Future<Task> toggleTaskStatus(String id, bool isCompleted) async {
    return updateTask(id: id, isCompleted: isCompleted);
  }

  /// ลบ Task
  ///
  /// Parameters:
  /// - id: ID ของ Task ที่ต้องการลบ
  Future<void> deleteTask(String id) async {
    try {
      await pb.collection(collectionName).delete(id);
    } catch (e) {
      print('Error deleting task: $e');
      rethrow;
    }
  }

  /// ตรวจสอบว่าเชื่อมต่อกับ PocketBase ได้หรือไม่
  ///
  /// Returns: true ถ้าเชื่อมต่อได้
  Future<bool> checkConnection() async {
    try {
      await pb.health.check();
      return true;
    } catch (e) {
      print('PocketBase connection failed: $e');
      return false;
    }
  }
}
