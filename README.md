# Simple To-Do App

แอปพลิเคชันจัดการงานส่วนตัว (Personal Task Manager) ที่สร้างด้วย Flutter และ PocketBase

## ภาพรวมโปรเจกต์

Simple To-Do App คือเครื่องมือจัดการรายการงาน (Task Management) ที่ช่วยให้ผู้ใช้สามารถ:
- ✅ เพิ่มงานใหม่
- 📋 แสดงรายการงานทั้งหมด
- ✏️ แก้ไขชื่องาน
- ☑️ เปลี่ยนสถานะงาน (เสร็จ/ยังไม่เสร็จ)
- 🗑️ ลบงาน (Swipe to delete)
- 🔄 Real-time sync กับฐานข้อมูล

## เทคโนโลยีที่ใช้

- **Frontend**: Flutter (Dart)
- **Backend**: PocketBase
- **State Management**: Built-in StatefulWidget
- **HTTP Client**: PocketBase SDK
- **Fake Data**: Faker package

## โครงสร้างโปรเจกต์

```
lib/
├── main.dart                    # จุดเริ่มต้นแอปพลิเคชัน
├── api/
│   └── pocketbase_api.dart      # API Service สำหรับเชื่อมต่อ PocketBase
├── models/
│   └── task_model.dart          # Task Data Model
├── screens/
│   ├── home_screen.dart         # หน้าจอหลัก (แสดงรายการงาน)
│   ├── add_task_screen.dart     # หน้าจอเพิ่มงานใหม่
│   └── edit_task_screen.dart    # หน้าจอแก้ไขงาน
└── widgets/
    └── task_list_item.dart      # Widget แสดง Task แต่ละรายการ

scripts/
└── generate_fake_tasks.dart     # สคริปต์สร้างข้อมูลจำลอง
```

## การติดตั้งและใช้งาน

### 1. ติดตั้ง Dependencies

ตรวจสอบให้แน่ใจว่าติดตั้ง Flutter SDK แล้ว:

```bash
flutter --version
```

ติดตั้ง packages:

```bash
flutter pub get
```

### 2. ติดตั้งและรัน PocketBase

#### ดาวน์โหลด PocketBase

ไปที่ [https://pocketbase.io/docs/](https://pocketbase.io/docs/) และดาวน์โหลดตามระบบปฏิบัติการของคุณ

#### รัน PocketBase Server

**macOS/Linux:**
```bash
# เปิด Terminal แล้วไปที่โฟลเดอร์ที่มีไฟล์ PocketBase
./pocketbase serve
```

**Windows:**
```bash
# เปิด Command Prompt แล้วไปที่โฟลเดอร์ที่มีไฟล์ PocketBase
pocketbase.exe serve
```

PocketBase จะรันที่ `http://127.0.0.1:8090`

### 3. สร้าง Collection ใน PocketBase

1. เปิดเบราว์เซอร์แล้วไปที่ `http://127.0.0.1:8090/_/`
2. สร้างบัญชี Admin (ครั้งแรก)
3. ไปที่เมนู **Collections** > คลิก **New collection**
4. ตั้งชื่อ collection: `tasks`
5. เพิ่ม Fields ดังนี้:
   - **title** (Text) - ชื่องาน
   - **is_completed** (Boolean) - สถานะงาน (เสร็จหรือไม่)

6. ไปที่แท็บ **API Rules** แล้วตั้งค่า:
   - **List/Search**: Allow everyone
   - **View**: Allow everyone
   - **Create**: Allow everyone
   - **Update**: Allow everyone
   - **Delete**: Allow everyone

   > **หมายเหตุ**: การตั้งค่านี้เหมาะสำหรับการพัฒนาเท่านั้น สำหรับ Production ควรมีการ Authentication

7. คลิก **Save**

### 4. ตั้งค่า PocketBase URL

เปิดไฟล์ `lib/main.dart` และเปลี่ยน URL ของ PocketBase:

```dart
PocketBaseAPI().initialize('http://127.0.0.1:8090');
```

**สำหรับการทดสอบบนอุปกรณ์จริง:**
- หา IP Address ของคอมพิวเตอร์คุณ
  - macOS/Linux: `ifconfig | grep "inet "`
  - Windows: `ipconfig`
- เปลี่ยน URL เป็น: `http://<YOUR_IP>:8090`

**สำหรับ Android Emulator:**
```dart
PocketBaseAPI().initialize('http://10.0.2.2:8090');
```

### 5. รันแอปพลิเคชัน

```bash
flutter run
```

หรือเลือกอุปกรณ์ที่ต้องการ:

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome
flutter run -d chrome
```

## การสร้างข้อมูลจำลอง (Faker)

หากต้องการสร้างข้อมูล Task จำลองเพื่อทดสอบ:

```bash
dart scripts/generate_fake_tasks.dart
```

สคริปต์นี้จะสร้าง Task 20 รายการแบบสุ่มลง PocketBase

## Features หลัก

### 1. CRUD Operations

#### Create (เพิ่มงานใหม่)
- กดปุ่ม Floating Action Button (+)
- กรอกชื่องานในฟอร์ม
- กดปุ่ม "บันทึก"

#### Read (แสดงรายการงาน)
- หน้าจอหลักจะแสดงงานทั้งหมดใน ListView
- Pull to refresh เพื่อโหลดข้อมูลใหม่

#### Update (แก้ไขงาน)
- กดที่รายการงานที่ต้องการแก้ไข หรือกดไอคอนดินสอ
- แก้ไขชื่องานในฟอร์ม
- กดปุ่ม "บันทึกการแก้ไข"

#### Delete (ลบงาน)
- **วิธีที่ 1**: Swipe รายการจากขวาไปซ้าย
- **วิธีที่ 2**: เปิดหน้าแก้ไขแล้วกดไอคอนถังขยะ

### 2. Toggle สถานะงาน

- กด Checkbox หน้ารายการงาน
- งานที่เสร็จแล้วจะมีชื่อขีดฆ่าและเปลี่ยนเป็นสีเทา

### 3. UI/UX Features

- Material Design 3
- Card-based layout
- Color coding (เขียว = เสร็จ, ส้ม = ยังไม่เสร็จ)
- Loading indicators
- Error handling with SnackBar
- Pull to refresh
- Empty state screen

## Functional Requirements

### FR-01: Create Task
ระบบต้องอนุญาตให้ผู้ใช้สร้างงานใหม่ได้ โดยต้องระบุชื่องานเป็นอย่างน้อย

### FR-02: Read Tasks
ระบบต้องแสดงรายการงานทั้งหมดของผู้ใช้ได้

### FR-03: Update Task Title
ระบบต้องอนุญาตให้ผู้ใช้แก้ไขชื่องานของรายการที่มีอยู่ได้

### FR-04: Update Task Status
ระบบต้องอนุญาตให้ผู้ใช้เปลี่ยนสถานะของงานเป็น "เสร็จแล้ว" หรือ "ยังไม่เสร็จ" ได้

### FR-05: Delete Task
ระบบต้องอนุญาตให้ผู้ใช้ลบงานที่ไม่ต้องการแล้วได้

## Workflow การใช้งาน

```
1. เปิดแอป
   ↓
2. หน้าจอหลักแสดงรายการงาน (โหลดจาก PocketBase)
   ↓
3. ผู้ใช้สามารถ:
   - กด + เพื่อเพิ่มงานใหม่
   - กด Checkbox เพื่อเปลี่ยนสถานะ
   - กดที่รายการเพื่อแก้ไข
   - Swipe เพื่อลบ
   ↓
4. ข้อมูลถูกซิงค์กับ PocketBase Real-time
   ↓
5. UI อัปเดตทันที
```

## การแก้ปัญหา (Troubleshooting)

### ❌ ไม่สามารถเชื่อมต่อ PocketBase

**ตรวจสอบ:**
1. PocketBase รันอยู่หรือไม่? (ดูที่ Terminal/CMD)
2. URL ใน `main.dart` ถูกต้องหรือไม่?
3. Firewall ของคุณอาจบล็อก port 8090

**แก้ไข:**
```bash
# ลองรัน PocketBase ด้วย host 0.0.0.0
./pocketbase serve --http="0.0.0.0:8090"
```

### ❌ API Error 404

**สาเหตุ:**
- Collection 'tasks' ยังไม่ถูกสร้างใน PocketBase

**แก้ไข:**
- ไปที่ PocketBase Admin UI และสร้าง collection 'tasks' ตามขั้นตอนในส่วน "3. สร้าง Collection ใน PocketBase"

### ❌ API Error 403

**สาเหตุ:**
- API Rules ของ collection 'tasks' ไม่อนุญาตให้ทำงาน

**แก้ไข:**
- ไปที่ PocketBase Admin > Collections > tasks > API Rules
- ตั้งค่าทุก operation เป็น "Allow everyone"

### ❌ Android Emulator ไม่เชื่อมต่อ

**แก้ไข:**
- เปลี่ยน URL เป็น `http://10.0.2.2:8090` แทน `http://127.0.0.1:8090`

## การพัฒนาต่อยอด

### ฟีเจอร์เพิ่มเติมที่แนะนำ:

1. **Authentication**
   - เพิ่มระบบ Login/Register
   - แยกข้อมูลตาม User

2. **Categories**
   - จัดกลุ่มงานตามหมวดหมู่
   - Filter ตามหมวดหมู่

3. **Priority**
   - กำหนดระดับความสำคัญ (สูง/กลาง/ต่ำ)
   - เรียงลำดับตามความสำคัญ

4. **Due Date**
   - กำหนดวันครบกำหนด
   - แจ้งเตือนเมื่อใกล้ครบกำหนด

5. **Search & Filter**
   - ค้นหางานตามชื่อ
   - กรองตามสถานะ

6. **Dark Mode**
   - รองรับโหมดมืด

## License

โปรเจกต์นี้สร้างขึ้นเพื่อการศึกษา

## ผู้พัฒนา

สร้างโดย: [ชื่อของคุณ]
สถาบัน: [ชื่อสถาบัน]
ปี: 2025

---

**Happy Coding!** 🚀
# Simple-To-Do-App
# To-do-app
# To-do-app
# To-do-app
# To-do-app
# Flutter-todo-Project
