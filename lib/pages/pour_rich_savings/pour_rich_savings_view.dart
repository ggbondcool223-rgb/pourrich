import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_savings_logic.dart';

class PourRichSavingsView extends GetView<PourRichSavingsLogic> {
  const PourRichSavingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: PourRichColors.primary,
        elevation: 0,
        title: const Text(
          'Savings Goals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: controller.showCreateGoalDialog,
          ),
        ],
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
              _buildSummaryCard(),
              SizedBox(height: 24.h),
              _buildGoalsList(),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.showCreateGoalDialog,
        backgroundColor: PourRichColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Goal'),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final totalSaved = controller.totalSaved;
      final totalTarget = controller.totalTarget;
      final completedCount = controller.completedGoalsCount;
      final totalCount = controller.goals.length;
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PourRichColors.primary,
              PourRichColors.primary.withValues(alpha: 0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Saved',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white70),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '\$${totalSaved.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.savings, color: Colors.white, size: 40.w),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryStat('Goals', totalCount.toString(), Icons.flag),
                  _buildSummaryStat(
                    'Completed',
                    completedCount.toString(),
                    Icons.check_circle,
                  ),
                  _buildSummaryStat(
                    'Target',
                    '\$${totalTarget.toStringAsFixed(0)}',
                    Icons.trending_up,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.w),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
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

  Widget _buildGoalsList() {
    return Obx(() {
      if (controller.goals.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              children: [
                Icon(
                  Icons.savings_outlined,
                  size: 80.w,
                  color: PourRichColors.textSecondary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No Savings Goals Yet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: PourRichColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Create your first savings goal\nto start tracking your progress!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: PourRichColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Goals',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...controller.goals.map((goal) => _buildGoalCard(goal)),
        ],
      );
    });
  }

  Widget _buildGoalCard(dynamic goal) {
    final progress = goal.progress;
    final isCompleted = goal.isCompleted;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCompleted
              ? PourRichColors.primary.withValues(alpha: 0.3)
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
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isCompleted
                  ? PourRichColors.primary.withValues(alpha: 0.1)
                  : PourRichColors.blue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? PourRichColors.primary
                        : PourRichColors.blue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_circle : Icons.savings,
                    color: Colors.white,
                    size: 24.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: PourRichColors.textPrimary,
                        ),
                      ),
                      if (goal.description != null) ...[
                        SizedBox(height: 2.h),
                        Text(
                          goal.description!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: PourRichColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isCompleted)
                  IconButton(
                    icon: Icon(Icons.add_circle, color: PourRichColors.primary),
                    onPressed: () => controller.showDepositDialog(goal),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${goal.currentAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: PourRichColors.primary,
                      ),
                    ),
                    Text(
                      'of \$${goal.targetAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: PourRichColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Stack(
                  children: [
                    Container(
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: PourRichColors.background,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        height: 12.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isCompleted
                                ? [
                                    PourRichColors.primary,
                                    PourRichColors.primaryDark,
                                  ]
                                : [
                                    PourRichColors.blue,
                                    PourRichColors.blue.withValues(alpha: 0.7),
                                  ],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${(progress * 100).toStringAsFixed(1)}% Complete',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: PourRichColors.textSecondary,
                      ),
                    ),
                    if (goal.deadline != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 12.w,
                            color: PourRichColors.textSecondary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            goal.deadline!.split('T')[0],
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: PourRichColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                if (isCompleted) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: PourRichColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: PourRichColors.gold,
                          size: 16.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Goal Achieved!',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: PourRichColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
