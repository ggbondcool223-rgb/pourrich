import 'package:get/get.dart';
import 'pour_rich_quiz_logic.dart';

class PourRichQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichQuizLogic());
  }
}
