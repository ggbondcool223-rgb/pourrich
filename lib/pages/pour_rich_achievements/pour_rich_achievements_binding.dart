import 'package:get/get.dart';
import 'pour_rich_achievements_logic.dart';

class PourRichAchievementsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichAchievementsLogic());
  }
}
