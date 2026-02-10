import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_achievements_logic.dart';

class PourRichAchievementsView extends GetView<PourRichAchievementsLogic> {
  const PourRichAchievementsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: PourRichColors.gold,
        elevation: 0,
        title: const Text(
          'Achievements',
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
        return Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            Expanded(child: _buildAchievementsList()),
          ],
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PourRichColors.gold,
              PourRichColors.gold.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildHeaderStat(
              icon: Icons.emoji_events,
              label: 'Unlocked',
              value:
                  '${controller.unlockedAchievements}/${controller.totalAchievements}',
            ),
            _buildHeaderStat(
              icon: Icons.trending_up,
              label: 'Progress',
              value: '${(controller.completionRate * 100).toStringAsFixed(0)}%',
            ),
            _buildHeaderStat(
              icon: Icons.monetization_on,
              label: 'Earned',
              value: controller.totalCoinsEarned.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28.w),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;
            return GestureDetector(
              onTap: () => controller.selectCategory(category),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? PourRichColors.gold : Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected
                        ? PourRichColors.gold
                        : PourRichColors.textSecondary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  controller.categoryLabels[category]!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : PourRichColors.textPrimary,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildAchievementsList() {
    return Obx(() {
      if (controller.achievements.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                size: 64.w,
                color: PourRichColors.textSecondary,
              ),
              SizedBox(height: 16.h),
              Text(
                'No achievements in this category',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: PourRichColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.achievements.length,
        itemBuilder: (context, index) {
          return _buildAchievementCard(controller.achievements[index]);
        },
      );
    });
  }

  Widget _buildAchievementCard(dynamic achievement) {
    final isAchieved = achievement.isAchieved;
    final rarityColor = controller.getRarityColor(achievement.rarity);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isAchieved
              ? rarityColor.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: rarityColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(12.r),
                ),
              ),
              child: Text(
                achievement.rarity.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAchieved
                        ? rarityColor.withValues(alpha: 0.2)
                        : PourRichColors.textSecondary.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    isAchieved ? Icons.emoji_events : Icons.lock,
                    color: isAchieved
                        ? rarityColor
                        : PourRichColors.textSecondary,
                    size: 32.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isAchieved
                              ? PourRichColors.textPrimary
                              : PourRichColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: PourRichColors.textSecondary,
                        ),
                      ),
                      if (achievement.rewardCoins > 0) ...[
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: PourRichColors.gold,
                              size: 16.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '+${achievement.rewardCoins} coins',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: PourRichColors.gold,
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (isAchieved && achievement.achievedAt != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          'Unlocked: ${achievement.achievedAt!.split('T')[0]}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: PourRichColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isAchieved)
            Positioned(
              top: 12.h,
              left: 12.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: rarityColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 16.w),
              ),
            ),
        ],
      ),
    );
  }
}
