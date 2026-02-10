import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_settings_logic.dart';

class PourRichSettingsView extends GetView<PourRichSettingsLogic> {
  const PourRichSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: PourRichColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        children: [
          _buildSectionTitle('Features'),
          _buildFeatureCard(
            title: 'Daily Tasks',
            description: 'Complete daily challenges and earn coins',
            icon: Icons.task_alt,
            color: PourRichColors.blue,
            onTap: () => Get.toNamed('/daily_tasks'),
          ),
          _buildFeatureCard(
            title: 'Savings Goals',
            description: 'Track your savings progress with visual goals',
            icon: Icons.savings,
            color: PourRichColors.primary,
            onTap: () => Get.toNamed('/savings'),
          ),
          _buildFeatureCard(
            title: 'Trivia Quiz',
            description: 'Test your knowledge and earn coins',
            icon: Icons.quiz,
            color: PourRichColors.blue,
            onTap: () => Get.toNamed('/quiz'),
          ),
          _buildFeatureCard(
            title: 'Achievements',
            description: 'Unlock badges and collect rewards',
            icon: Icons.emoji_events,
            color: PourRichColors.gold,
            onTap: () => Get.toNamed('/achievements'),
          ),
          _buildFeatureCard(
            title: 'Statistics Dashboard',
            description: 'View your progress and performance',
            icon: Icons.analytics,
            color: PourRichColors.blue,
            onTap: () => Get.toNamed('/stats'),
          ),
          _buildFeatureCard(
            title: 'Financial Calculator',
            description: 'Calculate compound interest, mortgage, and more',
            icon: Icons.calculate,
            color: PourRichColors.primaryDark,
            onTap: () => Get.toNamed('/calculator'),
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('Data Management'),
          _buildSettingItem(
            icon: Icons.delete_outline,
            iconColor: Colors.red,
            title: 'Delete All Data',
            onTap: () => controller.showDeleteConfirmDialog(),
            showArrow: true,
          ),
          SizedBox(height: 24.h),
          _buildSectionTitle('About'),
          _buildSettingItem(
            icon: Icons.info_outline,
            iconColor: PourRichColors.blue,
            title: 'Version',
            trailing: Obx(
              () => Text(
                controller.version.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: PourRichColors.textSecondary,
                ),
              ),
            ),
            showArrow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          color: PourRichColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: PourRichColors.textPrimary,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
                if (showArrow)
                  Icon(
                    Icons.chevron_right,
                    color: PourRichColors.textSecondary,
                    size: 20.w,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: color, size: 28.w),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: PourRichColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: PourRichColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.w,
                  color: PourRichColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
