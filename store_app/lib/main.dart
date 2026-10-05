import 'package:flutter/material.dart';
// تأكد من مسار وأسماء ملفات الصفحات بالضبط حسب الموجود عندك بمجلد pages:
import 'package:store_app/pages/home_page.dart';        // تأكد أن ملف home_page.dart يحتوي على HomePage.id
import 'package:store_app/pages/update_product_page.dart'; // تأكد أن ملف update_product_page.dart يحتوي على UpdateProductPage.id

void main() {
  runApp(const StoreApp());
}

class StoreApp extends StatelessWidget {
  const StoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.id,
      routes: {
        HomePage.id: (context) => const HomePage(),
        UpdateProductPage.id: (context) => const UpdateProductPage(),
      },
    );
  }
}