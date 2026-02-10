import 'package:get/get.dart';
import 'pour_rich_stats_logic.dart';

class PourRichStatsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichStatsLogic());
  }
}
