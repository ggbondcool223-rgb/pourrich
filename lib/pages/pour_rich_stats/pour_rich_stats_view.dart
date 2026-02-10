import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_stats_logic.dart';

class PourRichStatsView extends GetView<PourRichStatsLogic> {
  const PourRichStatsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: PourRichColors.blue,
        elevation: 0,
        title: const Text(
          'Statistics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCard(),
              SizedBox(height: 20.h),
              _buildSectionTitle('Game Performance'),
              _buildMonopolyCard(),
              SizedBox(height: 12.h),
              _buildChallengeCard(),
              SizedBox(height: 20.h),
              _buildSectionTitle('Learning Progress'),
              _buildTriviaCard(),
              SizedBox(height: 20.h),
              _buildSectionTitle('Financial Goals'),
              _buildSavingsCard(),
              SizedBox(height: 12.h),
              _buildAchievementsCard(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: PourRichColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PourRichColors.blue,
              PourRichColors.blue.withValues(alpha: 0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.monetization_on,
                  color: PourRichColors.gold,
                  size: 40.w,
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Coins',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                    Text(
                      '${controller.totalCoins.value}',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonopolyCard() {
    return Obx(
      () => _buildStatCard(
        title: 'Water Monopoly',
        icon: Icons.casino,
        color: PourRichColors.blue,
        stats: [
          _buildStatRow('Total Wins', '${controller.monopolyWins.value}'),
          _buildStatRow(
            'Best Record',
            '${controller.monopolyBestRecord.value} guesses',
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Obx(
      () => _buildStatCard(
        title: 'Water Challenge',
        icon: Icons.water_drop,
        color: PourRichColors.primary,
        stats: [
          _buildStatRow('Level', '${controller.challengeLevel.value}'),
          _buildStatRow('Total Score', '${controller.challengeScore.value}'),
          _buildStatRow(
            'Success Rate',
            '${(controller.challengeSuccessRate * 100).toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildTriviaCard() {
    return Obx(
      () => _buildStatCard(
        title: 'Trivia & Quiz',
        icon: Icons.school,
        color: PourRichColors.blue,
        stats: [
          _buildStatRow(
            'Articles Read',
            '${controller.triviaRead.value}/${controller.triviaTotal.value}',
          ),
          _buildStatRow(
            'Quiz Accuracy',
            '${(controller.quizAccuracy * 100).toStringAsFixed(1)}%',
          ),
          _buildStatRow('Correct Answers', '${controller.quizCorrect.value}'),
        ],
      ),
    );
  }

  Widget _buildSavingsCard() {
    return Obx(
      () => _buildStatCard(
        title: 'Savings Goals',
        icon: Icons.savings,
        color: PourRichColors.primary,
        stats: [
          _buildStatRow(
            'Total Saved',
            '\$${controller.savingsTotal.value.toStringAsFixed(2)}',
          ),
          _buildStatRow(
            'Goals Completed',
            '${controller.savingsGoalsCompleted.value}',
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsCard() {
    return Obx(
      () => _buildStatCard(
        title: 'Achievements',
        icon: Icons.emoji_events,
        color: PourRichColors.gold,
        stats: [
          _buildStatRow(
            'Unlocked',
            '${controller.achievementsUnlocked.value}/${controller.achievementsTotal.value}',
          ),
          _buildStatRow(
            'Progress',
            '${(controller.achievementProgress * 100).toStringAsFixed(1)}%',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> stats,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 24.w),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: PourRichColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...stats,
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: PourRichColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: PourRichColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
