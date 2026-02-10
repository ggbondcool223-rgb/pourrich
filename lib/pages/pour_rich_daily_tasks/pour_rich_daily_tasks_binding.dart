import 'package:get/get.dart';
import 'pour_rich_daily_tasks_logic.dart';

class PourRichDailyTasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichDailyTasksLogic());
  }
}
