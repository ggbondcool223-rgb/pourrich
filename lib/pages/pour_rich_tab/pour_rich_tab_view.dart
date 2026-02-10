import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/pages/pour_rich_home/pour_rich_home_view.dart';
import 'package:pour_rich/pages/pour_rich_water_challenge/pour_rich_water_challenge_view.dart';
import 'package:pour_rich/pages/pour_rich_trivia/pour_rich_trivia_view.dart';
import 'package:pour_rich/pages/pour_rich_financial_guide/pour_rich_financial_guide_view.dart';
import 'package:pour_rich/pages/pour_rich_settings/pour_rich_settings_view.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_tab_logic.dart';

class PourRichTabView extends GetView<PourRichTabLogic> {
  const PourRichTabView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            PourRichHomeView(),
            PourRichWaterChallengeView(),
            PourRichTriviaView(),
            PourRichFinancialGuideView(),
            PourRichSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomNavigationBar()),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: PourRichColors.textSecondary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h).copyWith(bottom: 18.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
              index: 0,
              isActive: controller.currentIndex.value == 0,
            ),
            _buildTabItem(
              icon: Icons.water_drop_outlined,
              activeIcon: Icons.water_drop,
              label: 'Challenge',
              index: 1,
              isActive: controller.currentIndex.value == 1,
            ),
            _buildTabItem(
              icon: Icons.emoji_objects_outlined,
              activeIcon: Icons.emoji_objects,
              label: 'Trivia',
              index: 2,
              isActive: controller.currentIndex.value == 2,
            ),
            _buildTabItem(
              icon: Icons.account_balance_wallet_outlined,
              activeIcon: Icons.account_balance_wallet,
              label: 'Finance',
              index: 3,
              isActive: controller.currentIndex.value == 3,
            ),
            _buildTabItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Settings',
              index: 4,
              isActive: controller.currentIndex.value == 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChange(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 24.w,
                color: isActive
                    ? PourRichColors.blue
                    : PourRichColors.textSecondary,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? PourRichColors.blue
                      : PourRichColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
