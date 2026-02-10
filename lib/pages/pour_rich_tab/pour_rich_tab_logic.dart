import 'package:get/get.dart';

class PourRichTabLogic extends GetxController {
  final currentIndex = 0.obs;
  void onTabChange(int index) {
    if (currentIndex.value == index) return;
    currentIndex.value = index;
  }
}
