/// Task Model
/// โมเดลคลาสสำหรับแทน Task (งาน) ในแอปพลิเคชัน
/// ใช้สำหรับแปลงข้อมูล JSON จาก PocketBase เป็น Dart Object และในทางกลับกัน
class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? created;
  final DateTime? updated;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.created,
    this.updated,
  });

  /// สร้าง Task object จาก JSON (ที่ได้จาก PocketBase API)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      created: json['created'] != null ? DateTime.parse(json['created']) : null,
      updated: json['updated'] != null ? DateTime.parse(json['updated']) : null,
    );
  }

  /// แปลง Task object เป็น JSON (สำหรับส่งไปยัง PocketBase API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'is_completed': isCompleted,
    };
  }

  /// สร้าง Task ใหม่โดยคัดลอกจาก Task เดิม แต่เปลี่ยนค่าบางค่า (Immutable pattern)
  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? created,
    DateTime? updated,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      created: created ?? this.created,
      updated: updated ?? this.updated,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, isCompleted: $isCompleted)';
  }
}
