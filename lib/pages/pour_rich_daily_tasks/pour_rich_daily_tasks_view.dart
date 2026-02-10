import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_daily_tasks_logic.dart';

class PourRichDailyTasksView extends GetView<PourRichDailyTasksLogic> {
  const PourRichDailyTasksView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: PourRichColors.blue,
        elevation: 0,
        title: const Text(
          'Daily Tasks',
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
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildProgressCard(),
                SizedBox(height: 24.h),
                _buildTasksList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PourRichColors.blue,
            PourRichColors.blue.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Coins',
                style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: PourRichColors.gold,
                      size: 28.w,
                    ),
                    SizedBox(width: 8.w),
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
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.emoji_events,
              color: PourRichColors.gold,
              size: 40.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Obx(() {
      final completionRate = controller.completionRate;
      final completed = controller.completedTasksCount;
      final total = controller.totalTasksCount;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: PourRichColors.textPrimary,
                  ),
                ),
                Text(
                  '$completed / $total',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: PourRichColors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: completionRate,
                minHeight: 8.h,
                backgroundColor: PourRichColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  completionRate == 1.0
                      ? PourRichColors.primary
                      : PourRichColors.blue,
                ),
              ),
            ),
            if (completionRate == 1.0) ...[
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: PourRichColors.primary,
                    size: 20.w,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'All tasks completed! Great job! 🎉',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: PourRichColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildTasksList() {
    return Obx(() {
      if (controller.tasks.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(40.w),
            child: Column(
              children: [
                Icon(
                  Icons.task_alt,
                  size: 64.w,
                  color: PourRichColors.textSecondary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No tasks available',
                  style: TextStyle(
                    fontSize: 16.sp,
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
            'Tasks',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...controller.tasks.map((task) => _buildTaskCard(task)),
        ],
      );
    });
  }

  Widget _buildTaskCard(dynamic task) {
    final isCompleted = task.isCompleted;
    final progress = task.currentValue / task.targetValue;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCompleted
              ? PourRichColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? PourRichColors.primary.withValues(alpha: 0.1)
                      : PourRichColors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isCompleted
                      ? PourRichColors.primary
                      : PourRichColors.blue,
                  size: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: PourRichColors.textPrimary,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: PourRichColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: PourRichColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: PourRichColors.gold,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '+${task.rewardCoins}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: PourRichColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isCompleted) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      backgroundColor: PourRichColors.background,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        PourRichColors.blue,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  '${task.currentValue}/${task.targetValue}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: PourRichColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
