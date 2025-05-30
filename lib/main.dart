import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/core/constants/routes.dart';
import 'package:notes_app/presentation/bindings/app_binding.dart';
import 'package:notes_app/presentation/pages/add_edit_note_page.dart';
import 'package:notes_app/presentation/pages/home_page.dart';
import 'package:notes_app/presentation/controllers/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController _themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Notes App',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.home,
      getPages: [
        GetPage(name: AppRoutes.home, page: () => HomePage()),
        GetPage(name: AppRoutes.addNote, page: () => AddEditNotePage()),
        GetPage(name: AppRoutes.editNote, page: () => AddEditNotePage()),
      ],
      theme: ThemeData.light().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      themeMode: _themeController.themeMode,
    );
  }
}
