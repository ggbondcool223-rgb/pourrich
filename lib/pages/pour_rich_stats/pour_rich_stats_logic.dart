import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';

class PourRichStatsLogic extends GetxController {
  final PourRichDatabase _db = Get.find<PourRichDatabase>();
  final isLoading = true.obs;
  final monopolyWins = 0.obs;
  final monopolyBestRecord = 0.obs;
  final challengeScore = 0.obs;
  final challengeLevel = 0.obs;
  final challengeSuccess = 0.obs;
  final challengeTotal = 0.obs;
  final triviaRead = 0.obs;
  final triviaTotal = 0.obs;
  final quizCorrect = 0.obs;
  final quizTotal = 0.obs;
  final savingsTotal = 0.0.obs;
  final savingsGoalsCompleted = 0.obs;
  final achievementsUnlocked = 0.obs;
  final achievementsTotal = 0.obs;
  final totalCoins = 0.obs;
  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    isLoading.value = true;
    try {
      final monopolyProgress = await _db.getMonopolyGameProgress();
      if (monopolyProgress != null) {
        monopolyWins.value = monopolyProgress.totalWins;
        monopolyBestRecord.value = monopolyProgress.bestRecord;
      }
      final challengeProfile = await _db.getWaterChallengeProfile();
      if (challengeProfile != null) {
        challengeScore.value = challengeProfile.totalScore;
        challengeLevel.value = challengeProfile.level;
        challengeSuccess.value = challengeProfile.totalSuccess;
        challengeTotal.value = challengeProfile.totalChallenges;
      }
      final db = await _db.database;
      final triviaCountResult = await db.rawQuery(
        'SELECT COUNT(*) as count FROM trivia',
      );
      triviaTotal.value = triviaCountResult.first['count'] as int;
      triviaRead.value = await _db.getReadTriviaCount();
      final quizStats = await _db.getQuizStats();
      quizTotal.value = quizStats['total']!;
      quizCorrect.value = quizStats['correct']!;
      final savingsGoals = await _db.getAllSavingsGoals();
      savingsTotal.value = savingsGoals.fold(
        0.0,
        (sum, goal) => sum + goal.currentAmount,
      );
      savingsGoalsCompleted.value = savingsGoals
          .where((g) => g.isCompleted)
          .length;
      final achievements = await _db.getAllAchievements();
      achievementsTotal.value = achievements.length;
      achievementsUnlocked.value = achievements
          .where((a) => a.isAchieved)
          .length;
      totalCoins.value = await _db.getCoinsBalance();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  double get challengeSuccessRate {
    if (challengeTotal.value == 0) return 0;
    return challengeSuccess.value / challengeTotal.value;
  }

  double get quizAccuracy {
    if (quizTotal.value == 0) return 0;
    return quizCorrect.value / quizTotal.value;
  }

  double get triviaReadProgress {
    if (triviaTotal.value == 0) return 0;
    return triviaRead.value / triviaTotal.value;
  }

  double get achievementProgress {
    if (achievementsTotal.value == 0) return 0;
    return achievementsUnlocked.value / achievementsTotal.value;
  }
}
