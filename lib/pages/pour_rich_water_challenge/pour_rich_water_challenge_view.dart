import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'package:pour_rich/components/pour_rich_water_cup.dart';
import 'pour_rich_water_challenge_logic.dart';

class PourRichWaterChallengeView extends GetView<PourRichWaterChallengeLogic> {
  const PourRichWaterChallengeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.water_drop, color: PourRichColors.blue, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              'Water Challenge',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: PourRichColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStatsSection(),
            _buildRulesSection(),
            _buildGameArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 12.w,
      ).copyWith(top: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
        border: Border(
          left: BorderSide(color: Colors.white),
          right: BorderSide(color: Colors.white),
          top: BorderSide(color: Colors.white),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0E0E0).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              Icons.star_rounded,
              'Score',
              '${controller.score.value}',
              PourRichColors.gold,
            ),
            Container(height: 40.h, width: 1.5, color: Colors.grey[300]),
            _buildStatItem(
              Icons.verified_rounded,
              'Level',
              '${controller.level.value} (${controller.levelProgress.value}%)',
              PourRichColors.blue,
            ),
            Container(height: 40.h, width: 1.5, color: Colors.grey[300]),
            _buildStatItem(
              Icons.emoji_events_rounded,
              'Best',
              '${controller.highScore.value}',
              Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22.w),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: PourRichColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: PourRichColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRulesSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: PourRichColors.cardBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            color: PourRichColors.blue.withOpacity(0.08),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRuleItem(
            Icons.info_outline,
            'Goal: Pour water into the cup to get as close to the target amount as possible.',
          ),
          SizedBox(height: 8.h),
          _buildRuleItem(
            Icons.check_circle_outline,
            'Higher accuracy = higher score! Higher level = harder challenge!',
          ),
          SizedBox(height: 8.h),
          _buildRuleItem(
            Icons.touch_app,
            'Press and hold the button to pour water, release to stop and judge the result.',
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: PourRichColors.blue, size: 18.w),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: PourRichColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            'Target: ${controller.targetAmount.value}ml',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
        ),
        Obx(
          () => Text(
            'Error Range: ${controller.errorRange.value}ml',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: PourRichColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentAmount() {
    return Obx(
      () => Text(
        '${controller.currentAmount.value}ml',
        style: TextStyle(
          fontSize: 56.sp,
          fontWeight: FontWeight.bold,
          color: PourRichColors.blue,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    const maxAmount = 1000.0;
    return Obx(() {
      final progress = (controller.currentAmount.value / maxAmount).clamp(
        0.0,
        1.0,
      );
      final lowerBound =
          ((controller.targetAmount.value - controller.errorRange.value) /
                  maxAmount)
              .clamp(0.0, 1.0);
      final upperBound =
          ((controller.targetAmount.value + controller.errorRange.value) /
                  maxAmount)
              .clamp(0.0, 1.0);
      final error =
          (controller.currentAmount.value - controller.targetAmount.value)
              .abs();
      final isInSuccessRange = error <= controller.errorRange.value;
      return Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final lowerPosition = lowerBound * width;
              final upperPosition = upperBound * width;
              return Stack(
                children: [
                  if (lowerBound < upperBound)
                    Positioned(
                      left: lowerPosition,
                      width: upperPosition - lowerPosition,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.25),
                          border: Border(
                            left: BorderSide(
                              color: Colors.green.withOpacity(0.5),
                              width: 2,
                            ),
                            right: BorderSide(
                              color: Colors.red.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isInSuccessRange
                                ? [Colors.green.shade400, Colors.green.shade500]
                                : [
                                    PourRichColors.blue,
                                    PourRichColors.blue.withOpacity(0.8),
                                  ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6.r),
                            bottomLeft: Radius.circular(6.r),
                            topRight: progress >= 0.99
                                ? Radius.circular(6.r)
                                : Radius.zero,
                            bottomRight: progress >= 0.99
                                ? Radius.circular(6.r)
                                : Radius.zero,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: lowerPosition - 4.w,
                    child: Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: upperPosition - 4.w,
                    child: Center(
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildInstructions() {
    return Text(
      'Press and hold to pour...release to stop',
      style: TextStyle(fontSize: 13.sp, color: PourRichColors.textSecondary),
    );
  }

  Widget _buildPourButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: Obx(
        () => Listener(
          onPointerDown: (_) => controller.startPouring(),
          onPointerUp: (_) => controller.stopPouring(),
          child: Container(
            decoration: BoxDecoration(
              color: controller.isPour.value
                  ? PourRichColors.primary
                  : PourRichColors.blue,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color:
                      (controller.isPour.value
                              ? PourRichColors.primary
                              : PourRichColors.blue)
                          .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isPour.value
                      ? Icons.water_drop
                      : Icons.water_drop_outlined,
                  size: 24.w,
                  color: Colors.white,
                ),
                SizedBox(width: 8.w),
                Text(
                  controller.isPour.value ? 'Pouring...' : 'Hold to Pour',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE0E0E0).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChallengeInfo(),
          SizedBox(height: 12.h),
          _buildCurrentAmount(),
          _buildProgressBar(),
          SizedBox(height: 12.h),
          Obx(
            () => PourRichWaterCup(
              waterAmount: controller.currentAmount.value,
              maxAmount: 1000,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInstructions(),
          SizedBox(height: 16.h),
          _buildPourButton(),
        ],
      ),
    );
  }
}
