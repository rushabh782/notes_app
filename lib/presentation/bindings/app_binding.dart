import 'package:get/get.dart';
import '../../data/services/database_service.dart';
import '../controllers/note_controller.dart';
import '../controllers/theme_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DatabaseService(), fenix: true);
    Get.lazyPut(() => NoteController(), fenix: true);
    Get.lazyPut(() => ThemeController(), fenix: true);
  }
}
