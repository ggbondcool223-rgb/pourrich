import 'package:get/get.dart';
import 'pour_rich_calculator_logic.dart';

class PourRichCalculatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichCalculatorLogic());
  }
}
