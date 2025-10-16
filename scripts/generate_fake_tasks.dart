import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:faker/faker.dart';

/// สคริปต์สำหรับสร้างข้อมูล Task จำลอง (Fake Data)
/// ใช้แพ็กเกจ Faker สร้างชื่องานแบบสุ่ม แล้วส่งไปยัง PocketBase
///
/// วิธีใช้งาน:
/// 1. ตรวจสอบให้แน่ใจว่า PocketBase รันอยู่ที่ http://127.0.0.1:8090
/// 2. สร้าง collection ชื่อ 'tasks' ใน PocketBase Admin UI
/// 3. เพิ่ม fields: title (text), is_completed (bool)
/// 4. รันสคริปต์นี้: dart scripts/generate_fake_tasks.dart

const String pocketbaseUrl = 'http://127.0.0.1:8090';
const String collectionName = 'tasks';

void main() async {
  print('🚀 เริ่มต้นสร้างข้อมูลจำลอง...\n');

  // จำนวน Tasks ที่ต้องการสร้าง
  const int numberOfTasks = 20;

  final faker = Faker();
  int successCount = 0;
  int failCount = 0;

  for (int i = 1; i <= numberOfTasks; i++) {
    try {
      // สร้างชื่องานแบบสุ่มด้วย Faker
      String taskTitle = _generateRandomTaskTitle(faker);

      // สุ่มสถานะ (70% ยังไม่เสร็จ, 30% เสร็จแล้ว)
      bool isCompleted = faker.randomGenerator.integer(100) < 30;

      // สร้าง Task ใน PocketBase
      final success = await createTask(taskTitle, isCompleted);

      if (success) {
        successCount++;
        print(
            '✅ [$i/$numberOfTasks] สร้างสำเร็จ: "$taskTitle" (${isCompleted ? "เสร็จแล้ว" : "ยังไม่เสร็จ"})');
      } else {
        failCount++;
        print('❌ [$i/$numberOfTasks] สร้างไม่สำเร็จ: "$taskTitle"');
      }
    } catch (e) {
      failCount++;
      print('❌ [$i/$numberOfTasks] เกิดข้อผิดพลาด: $e');
    }

    // รอสักครู่เพื่อไม่ให้ส่ง request เร็วเกินไป
    await Future.delayed(Duration(milliseconds: 100));
  }

  print('\n' + '=' * 50);
  print('✨ สร้างข้อมูลเสร็จสิ้น!');
  print('   สำเร็จ: $successCount');
  print('   ล้มเหลว: $failCount');
  print('=' * 50);
}

/// สร้าง Task ใน PocketBase
Future<bool> createTask(String title, bool isCompleted) async {
  try {
    final url = Uri.parse('$pocketbaseUrl/api/collections/$collectionName/records');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': title,
        'is_completed': isCompleted,
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('   Error: $e');
    return false;
  }
}

/// สร้างชื่องานแบบสุ่ม
String _generateRandomTaskTitle(Faker faker) {
  // รายการ template สำหรับสร้างชื่องาน
  final templates = [
    // งานบ้าน
    'ทำความสะอาด${faker.randomGenerator.element(["ห้องนอน", "ห้องครัว", "ห้องน้ำ", "ห้องนั่งเล่น", "บ้าน"])}',
    'ซักผ้า${faker.randomGenerator.element(["", " และตากผ้า", " และเก็บผ้า"])}',
    'ล้างจาน${faker.randomGenerator.element(["", " หลังอาหาร", " ในอ่าง"])}',
    'รดน้ำต้นไม้${faker.randomGenerator.element(["", " ในสวน", " หน้าบ้าน"])}',
    'ซื้อของใช้ในบ้าน',

    // งานเรียน/งาน
    'ทำการบ้าน${faker.randomGenerator.element(["คณิตศาสตร์", "วิทยาศาสตร์", "ภาษาอังกฤษ", "ภาษาไทย", "สังคม"])}',
    'อ่านหนังสือ${faker.randomGenerator.element(["", " บทที่ ${faker.randomGenerator.integer(10, min: 1)}"])}',
    'เตรียมนำเสนอ${faker.randomGenerator.element(["", " โปรเจกต์", " งานกลุ่ม"])}',
    'ทำรายงาน${faker.randomGenerator.element(["", " ส่งอาจารย์", " กลุ่ม"])}',
    'ประชุม${faker.randomGenerator.element(["ทีม", "แผนก", "โปรเจกต์"])}',

    // งานส่วนตัว
    'ออกกำลังกาย${faker.randomGenerator.element(["", " 30 นาที", " ที่ยิม", " วิ่ง"])}',
    'ไปตัดผม',
    'นัดหมายหมอ${faker.randomGenerator.element(["", "ฟัน", " ตรวจสุขภาพ"])}',
    'ซ่อม${faker.randomGenerator.element(["รถยนต์", "จักรยาน", "คอมพิวเตอร์", "โทรศัพท์"])}',
    'เติมเงินมือถือ',

    // ช็อปปิ้ง
    'ซื้อ${faker.randomGenerator.element(["อาหาร", "ผัก", "ผลไม้", "ขนม", "เครื่องดื่ม"])}',
    'ไปตลาด${faker.randomGenerator.element(["", " ซื้อของสด", " เช้า"])}',
    'ไป${faker.randomGenerator.element(["7-11", "ห้างสรรพสินค้า", "ร้านสะดวกซื้อ"])}',

    // สังคม
    'โทรหา${faker.randomGenerator.element(["พ่อแม่", "เพื่อน", "ญาติ", "พี่น้อง"])}',
    'ส่งอีเมล${faker.randomGenerator.element(["", " ถึงเจ้านาย", " ติดตามงาน"])}',
    'ตอบข้อความ${faker.randomGenerator.element(["", " ใน Line", " ที่ค้างไว้"])}',
    'จัดปาร์ตี้${faker.randomGenerator.element(["วันเกิด", "สังสรรค์", "เลี้ยงฉลอง"])}',

    // การเงิน
    'จ่ายบิล${faker.randomGenerator.element(["ไฟฟ้า", "ประปา", "อินเทอร์เน็ต", "โทรศัพท์"])}',
    'โอนเงิน${faker.randomGenerator.element(["ค่าเช่า", "ค่างวด", ""])}',
    'ตรวจสอบบัญชีธนาคาร',

    // เทคโนโลยี
    'อัปเดต${faker.randomGenerator.element(["แอป", "ระบบปฏิบัติการ", "ซอฟต์แวร์"])}',
    'สำรองข้อมูล${faker.randomGenerator.element(["", " คอมพิวเตอร์", " โทรศัพท์"])}',
    'ติดตั้ง${faker.randomGenerator.element(["แอป", "โปรแกรม", "ระบบ"])}',

    // อื่นๆ
    'วางแผน${faker.randomGenerator.element(["วันหยุด", "ทริป", "งาน", "สัปดาห์หน้า"])}',
    'จองตั๋ว${faker.randomGenerator.element(["เครื่องบิน", "รถไฟ", "คอนเสิร์ต", "หนัง"])}',
    'เช็ค${faker.randomGenerator.element(["อีเมล", "ข่าว", "โซเชียลมีเดีย"])}',
  ];

  return faker.randomGenerator.element(templates);
}
