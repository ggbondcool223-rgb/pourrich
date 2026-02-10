import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pour_rich/db_pour_rich/data.dart';
import 'package:pour_rich/db_pour_rich/db_pour_rich_entity.dart';
import 'package:pour_rich/utils/index.dart';

class PourRichWaterChallengeLogic extends GetxController {
  final _db = Get.find<PourRichDatabase>();
  final score = 0.obs;
  final level = 1.obs;
  final levelProgress = 0.obs;
  final highScore = 0.obs;
  final consecutiveWins = 0.obs;
  final totalChallenges = 0.obs;
  final totalSuccess = 0.obs;
  final targetAmount = 500.obs;
  final errorRange = 25.obs;
  final currentAmount = 0.obs;
  final isPour = false.obs;
  final pourSpeed = 120.0;
  Timer? _pourTimer;
  WaterChallengeProfile? _profile;
  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    _pourTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadProfile() async {
    try {
      _profile = await _db.getWaterChallengeProfile();
      if (_profile != null) {
        score.value = _profile!.totalScore;
        level.value = _profile!.level;
        highScore.value = _profile!.highestScore;
        consecutiveWins.value = _profile!.consecutiveWins;
        totalChallenges.value = _profile!.totalChallenges;
        totalSuccess.value = _profile!.totalSuccess;
        _updateLevelProgress();
        _generateNewChallenge();
      }
    } catch (e) {
      errorToast('Failed to load profile');
    }
  }

  void _updateLevelProgress() {
    final currentLevelScore = _getScoreForLevel(level.value);
    final nextLevelScore = _getScoreForLevel(level.value + 1);
    final progress =
        ((score.value - currentLevelScore) /
                (nextLevelScore - currentLevelScore) *
                100)
            .clamp(0, 100)
            .toInt();
    levelProgress.value = progress;
  }

  int _getScoreForLevel(int lv) {
    return (lv - 1) * 500;
  }

  void _generateNewChallenge() {
    final random = Random();
    final minTarget = 200 + (level.value - 1) * 50;
    final maxTarget = 800 + (level.value - 1) * 50;
    targetAmount.value = minTarget + random.nextInt(maxTarget - minTarget);
    errorRange.value = (40 - level.value * 2).clamp(15, 40);
    currentAmount.value = 0;
  }

  void startPouring() {
    if (isPour.value) return;
    isPour.value = true;
    currentAmount.value = 0;
    _pourTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (!isPour.value) {
        timer.cancel();
        return;
      }
      final increment = (pourSpeed * 0.1).round();
      currentAmount.value += increment;
      if (currentAmount.value >= 1000) {
        currentAmount.value = 1000;
        stopPouring();
      }
    });
  }

  void stopPouring() async {
    if (!isPour.value) return;
    isPour.value = false;
    _pourTimer?.cancel();
    await _judgeResult();
  }

  Future<void> _judgeResult() async {
    try {
      final error = (currentAmount.value - targetAmount.value).abs();
      final isSuccess = error <= errorRange.value;
      final earnedScore = _calculateScore(error, isSuccess);
      if (isSuccess) {
        consecutiveWins.value++;
      } else {
        consecutiveWins.value = 0;
      }
      totalChallenges.value++;
      if (isSuccess) {
        totalSuccess.value++;
      }
      score.value += earnedScore;
      bool leveledUp = false;
      final nextLevelScore = _getScoreForLevel(level.value + 1);
      if (score.value >= nextLevelScore) {
        level.value++;
        leveledUp = true;
        if (level.value == 10) {
          await _unlockAchievement('level_10');
        }
      }
      if (score.value > highScore.value) {
        highScore.value = score.value;
      }
      _updateLevelProgress();
      await _saveHistory(isSuccess, error, earnedScore);
      await _saveProfile();
      await _checkAchievements(isSuccess, error);
      _showResultDialog(isSuccess, error, earnedScore, leveledUp);
    } catch (e) {
      errorToast('Failed to process result');
    }
  }

  int _calculateScore(int error, bool isSuccess) {
    if (!isSuccess) {
      return 5;
    }
    final baseScore = 100;
    final deduction = (error * 2).clamp(0, 90);
    return baseScore - deduction;
  }

  Future<void> _saveHistory(bool isSuccess, int error, int earnedScore) async {
    try {
      final history = WaterChallengeHistory(
        targetAmount: targetAmount.value,
        actualAmount: currentAmount.value,
        errorAmount: error,
        score: earnedScore,
        isSuccess: isSuccess,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _db.insertWaterChallengeHistory(history);
      if (isSuccess) {
        await _db.updateDailyTaskProgress(
          'challenge_win_3',
          totalSuccess.value,
        );
      }
    } catch (e) {}
  }

  Future<void> _saveProfile() async {
    try {
      if (_profile != null) {
        final updated = WaterChallengeProfile(
          id: _profile!.id,
          totalScore: score.value,
          level: level.value,
          highestScore: highScore.value,
          consecutiveWins: consecutiveWins.value,
          totalChallenges: totalChallenges.value,
          totalSuccess: totalSuccess.value,
          updatedAt: DateTime.now().toIso8601String(),
        );
        await _db.updateWaterChallengeProfile(updated);
        _profile = updated;
      }
    } catch (e) {}
  }

  Future<void> _checkAchievements(bool isSuccess, int error) async {
    try {
      if (isSuccess) {
        if (totalSuccess.value == 1) {
          await _unlockAchievement('first_success');
        }
        if (error == 0) {
          await _unlockAchievement('perfect_shot');
        }
        if (consecutiveWins.value == 10) {
          await _unlockAchievement('win_streak_10');
        }
      }
      if (totalChallenges.value == 100) {
        await _unlockAchievement('challenge_100');
      }
    } catch (e) {}
  }

  Future<void> _unlockAchievement(String key) async {
    try {
      final result = await _db.unlockAchievement(key);
      if (result > 0) {
        successToast('🎉 Achievement Unlocked!');
      }
    } catch (e) {}
  }

  void _showResultDialog(
    bool isSuccess,
    int error,
    int earnedScore,
    bool leveledUp,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text(
          isSuccess ? '🎉 Success!' : '😢 Failed!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leveledUp) ...[
              Text(
                '✨ Level Up! Now Level ${level.value}! ✨',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 12),
            ],
            Text(
              isSuccess
                  ? 'Great! Your amount is very close to target!'
                  : 'Almost! Try again!',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            _buildResultRow('Target:', '${targetAmount.value}ml'),
            _buildResultRow('Your Amount:', '${currentAmount.value}ml'),
            _buildResultRow(
              'Error:',
              '${error}ml',
              color: isSuccess ? Colors.green : Colors.red,
            ),
            _buildResultRow('Score:', '+$earnedScore', color: Colors.orange),
            if (consecutiveWins.value >= 3) ...[
              SizedBox(height: 8),
              Text(
                '🔥 ${consecutiveWins.value} Win Streak!',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onNextChallenge();
            },
            child: Text('Next Challenge'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildResultRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void onNextChallenge() {
    _generateNewChallenge();
  }

  void onRetry() {
    currentAmount.value = 0;
  }
}
