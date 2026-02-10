import 'package:get/get.dart';
import 'package:pour_rich/pages/pour_rich_home/pour_rich_home_logic.dart';
import 'package:pour_rich/pages/pour_rich_water_challenge/pour_rich_water_challenge_logic.dart';
import 'package:pour_rich/pages/pour_rich_trivia/pour_rich_trivia_logic.dart';
import 'package:pour_rich/pages/pour_rich_financial_guide/pour_rich_financial_guide_logic.dart';
import 'package:pour_rich/pages/pour_rich_settings/pour_rich_settings_logic.dart';
import 'pour_rich_tab_logic.dart';

class PourRichTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PourRichTabLogic());
    Get.lazyPut(() => PourRichHomeLogic());
    Get.lazyPut(() => PourRichWaterChallengeLogic());
    Get.lazyPut(() => PourRichTriviaLogic());
    Get.lazyPut(() => PourRichFinancialGuideLogic());
    Get.lazyPut(() => PourRichSettingsLogic());
  }
}
