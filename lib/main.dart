import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pour_rich/pages/pour_rich_tab/pour_rich_tab_view.dart';
import 'package:pour_rich/pages/pour_rich_tab/pour_rich_tab_binding.dart';
import 'package:pour_rich/pages/pour_rich_daily_tasks/pour_rich_daily_tasks_view.dart';
import 'package:pour_rich/pages/pour_rich_daily_tasks/pour_rich_daily_tasks_binding.dart';
import 'package:pour_rich/pages/pour_rich_savings/pour_rich_savings_view.dart';
import 'package:pour_rich/pages/pour_rich_savings/pour_rich_savings_binding.dart';
import 'package:pour_rich/pages/pour_rich_quiz/pour_rich_quiz_view.dart';
import 'package:pour_rich/pages/pour_rich_quiz/pour_rich_quiz_binding.dart';
import 'package:pour_rich/pages/pour_rich_achievements/pour_rich_achievements_view.dart';
import 'package:pour_rich/pages/pour_rich_achievements/pour_rich_achievements_binding.dart';
import 'package:pour_rich/pages/pour_rich_stats/pour_rich_stats_view.dart';
import 'package:pour_rich/pages/pour_rich_stats/pour_rich_stats_binding.dart';
import 'package:pour_rich/pages/pour_rich_calculator/pour_rich_calculator_view.dart';
import 'package:pour_rich/pages/pour_rich_calculator/pour_rich_calculator_binding.dart';
import 'package:pour_rich/utils/colors.dart';
import 'package:pour_rich/db_pour_rich/data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final db = await Get.putAsync(() async => PourRichDatabase());
  try {
    await db.generateDailyTasks();
  } catch (e) {}
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          getPages: Gem,
          initialRoute: '/pour_tab',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: PourRichColors.primary,
            scaffoldBackgroundColor: PourRichColors.background,
            colorScheme: ColorScheme.light(
              primary: PourRichColors.primary,
              surface: Colors.white,
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: PourRichColors.textPrimary,
              ),
              toolbarHeight: 42,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                size: 24,
                color: PourRichColors.textPrimary,
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: PourRichColors.blue,
              unselectedItemColor: PourRichColors.textSecondary,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            dividerTheme: DividerThemeData(
              thickness: 1,
              color: Colors.grey[200],
            ),
          ),
          builder: (context, child) {
            return GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: child,
            );
          },
        );
      },
    );
  }
}
List<GetPage<dynamic>> Gem = [
  GetPage(
    name: '/pour_tab',
    page: () => const PourRichTabView(),
    binding: PourRichTabBinding(),
  ),
  GetPage(
    name: '/daily_tasks',
    page: () => const PourRichDailyTasksView(),
    binding: PourRichDailyTasksBinding(),
  ),
  GetPage(
    name: '/savings',
    page: () => const PourRichSavingsView(),
    binding: PourRichSavingsBinding(),
  ),
  GetPage(
    name: '/quiz',
    page: () => const PourRichQuizView(),
    binding: PourRichQuizBinding(),
  ),
  GetPage(
    name: '/achievements',
    page: () => const PourRichAchievementsView(),
    binding: PourRichAchievementsBinding(),
  ),
  GetPage(
    name: '/stats',
    page: () => const PourRichStatsView(),
    binding: PourRichStatsBinding(),
  ),
  GetPage(
    name: '/calculator',
    page: () => const PourRichCalculatorView(),
    binding: PourRichCalculatorBinding(),
  ),
];