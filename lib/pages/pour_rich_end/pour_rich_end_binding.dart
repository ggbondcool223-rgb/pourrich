import 'package:get/get.dart';

import 'pour_rich_end_logic.dart';

class PourRichEndBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PourRichEndLogic(),
      permanent: true,
    );
  }
}
