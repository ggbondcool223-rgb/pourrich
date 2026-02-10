import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';

class PourRichAchievementsLogic extends GetxController {
  final PourRichDatabase _db = Get.find<PourRichDatabase>();
  final achievements = <GlobalAchievement>[].obs;
  final selectedCategory = 'all'.obs;
  final isLoading = true.obs;
  final categories = [
    'all',
    'monopoly',
    'challenge',
    'trivia',
    'financial',
    'global',
  ];
  final categoryLabels = {
    'all': 'All',
    'monopoly': 'Monopoly',
    'challenge': 'Challenge',
    'trivia': 'Trivia',
    'financial': 'Financial',
    'global': 'Global',
  };
  @override
  void onInit() {
    super.onInit();
    loadAchievements();
  }

  Future<void> loadAchievements() async {
    isLoading.value = true;
    try {
      if (selectedCategory.value == 'all') {
        achievements.value = await _db.getAllAchievements();
      } else {
        achievements.value = await _db.getAchievementsByCategory(
          selectedCategory.value,
        );
      }
    } catch (e) {
      print('Error loading achievements: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    loadAchievements();
  }

  int get totalAchievements => achievements.length;
  int get unlockedAchievements =>
      achievements.where((a) => a.isAchieved).length;
  double get completionRate {
    if (totalAchievements == 0) return 0;
    return unlockedAchievements / totalAchievements;
  }

  int get totalCoinsEarned {
    return achievements
        .where((a) => a.isAchieved)
        .fold(0, (sum, a) => sum + a.rewardCoins);
  }

  Color getRarityColor(String rarity) {
    switch (rarity) {
      case 'bronze':
        return const Color(0xFFCD7F32);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'diamond':
        return const Color(0xFFB9F2FF);
      default:
        return const Color(0xFF757575);
    }
  }
}
