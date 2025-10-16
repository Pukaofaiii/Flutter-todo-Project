import 'package:flutter/material.dart';
import 'api/pocketbase_api.dart';
import 'screens/home_screen.dart';

void main() {
  // เริ่มต้นแอปพลิเคชัน
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // เชื่อมต่อกับ PocketBase Server
    // **สำคัญ**: ต้องเปลี่ยน URL นี้ให้ตรงกับที่ PocketBase ของคุณรันอยู่
    //
    // สำหรับการพัฒนาในเครื่อง (Local Development):
    // - ถ้ารัน PocketBase บนเครื่องเดียวกัน: http://127.0.0.1:8090
    // - ถ้าทดสอบบน Android Emulator: http://10.0.2.2:8090
    // - ถ้าทดสอบบน iOS Simulator: http://127.0.0.1:8090
    // - ถ้าทดสอบบนเครื่องจริง: http://<YOUR_COMPUTER_IP>:8090
    //
    // สำหรับ Production:
    // - ใช้ URL ของเซิร์ฟเวอร์จริง เช่น https://your-domain.com
    //
    // วิธีหา IP ของคอมพิวเตอร์:
    // - macOS/Linux: เปิด Terminal แล้วพิมพ์ ifconfig | grep "inet "
    // - Windows: เปิด Command Prompt แล้วพิมพ์ ipconfig

    // สำหรับ Android Emulator ใช้ 10.0.2.2 แทน 127.0.0.1
    // สำหรับ Web/iOS/Desktop ใช้ 127.0.0.1
    const String pocketbaseUrl = bool.fromEnvironment('dart.library.js_util')
        ? 'http://127.0.0.1:8090'  // Web
        : 'http://10.0.2.2:8090';   // Android Emulator

    PocketBaseAPI().initialize(pocketbaseUrl);

    return MaterialApp(
      title: 'TaskFlow Pro',
      debugShowCheckedModeBanner: false,

      // Modern Professional Theme - Navy Blue
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Navy Blue
          brightness: Brightness.light,
          primary: const Color(0xFF1E3A8A), // Navy Blue
          secondary: const Color(0xFF2563EB), // Bright Blue
          tertiary: const Color(0xFF3B82F6), // Sky Blue
          surface: const Color(0xFFFAFAFA),
          background: const Color(0xFFF0F4F8),
        ),
        useMaterial3: true,

        // Typography
        fontFamily: 'Sarabun',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.15,
          ),
        ),

        // AppBar Theme
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1F2937),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
        ),

        // FloatingActionButton Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF6366F1),
              width: 2,
            ),
          ),
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}
