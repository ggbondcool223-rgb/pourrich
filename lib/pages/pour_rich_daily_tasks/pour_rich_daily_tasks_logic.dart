import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';

class PourRichDailyTasksLogic extends GetxController {
  final PourRichDatabase _db = Get.find<PourRichDatabase>();
  final tasks = <DailyTask>[].obs;
  final totalCoins = 0.obs;
  final isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      print('🔍 Loading daily tasks data...');
      await _db.generateDailyTasks();
      tasks.value = await _db.getTodayTasks();
      print('📋 Loaded ${tasks.value.length} tasks');
      for (var task in tasks.value) {
        print('  - ${task.title}: ${task.currentValue}/${task.targetValue}');
      }
      totalCoins.value = await _db.getCoinsBalance();
      print('💰 Total coins: ${totalCoins.value}');
    } catch (e) {
      print('❌ Error loading daily tasks: $e');
      print('Stack trace: ${StackTrace.current}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadData();
  }

  Future<void> checkTaskProgress(String taskKey, int progress) async {
    try {
      final taskIndex = tasks.indexWhere(
        (t) => t.taskKey == taskKey && !t.isCompleted,
      );
      if (taskIndex == -1) return;
      final task = tasks[taskIndex];
      await _db.updateTaskProgress(task.id!, progress);
      if (progress >= task.targetValue) {
        final success = await _db.completeTask(task.id!);
        if (success) {
          await loadData();
          Get.snackbar(
            'Task Completed! 🎉',
            'You earned ${task.rewardCoins} coins!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
          await _db.checkAndUnlockAchievements();
        }
      } else {
        tasks[taskIndex] = DailyTask(
          id: task.id,
          taskKey: task.taskKey,
          title: task.title,
          description: task.description,
          targetValue: task.targetValue,
          currentValue: progress,
          rewardCoins: task.rewardCoins,
          isCompleted: task.isCompleted,
          taskDate: task.taskDate,
          createdAt: task.createdAt,
        );
        tasks.refresh();
      }
    } catch (e) {
      print('Error checking task progress: $e');
    }
  }

  int get completedTasksCount => tasks.where((t) => t.isCompleted).length;
  int get totalTasksCount => tasks.length;
  double get completionRate {
    if (totalTasksCount == 0) return 0;
    return completedTasksCount / totalTasksCount;
  }
}
