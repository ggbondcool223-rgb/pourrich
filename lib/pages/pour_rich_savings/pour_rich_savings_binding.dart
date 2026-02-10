import 'package:get/get.dart';
import 'pour_rich_savings_logic.dart';

class PourRichSavingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichSavingsLogic());
  }
}
