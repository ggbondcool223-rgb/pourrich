import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'package:pour_rich/components/pour_rich_number_keyboard.dart';
import 'package:pour_rich/components/pour_rich_water_cup.dart';
import 'package:pour_rich/components/pour_rich_game_board.dart';
import 'pour_rich_home_logic.dart';

class PourRichHomeView extends GetView<PourRichHomeLogic> {
  const PourRichHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 12.h),
                    _buildPositionCard(),
                    SizedBox(height: 12.h),
                    _buildGameCard(),
                    SizedBox(height: 32.h),
                    _buildGameBoard(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ).copyWith(top: 50.h, left: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF29B6F6).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Water Monopoly',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelpDialog,
            iconSize: 26.w,
            padding: EdgeInsets.all(6.w),
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Text(
              'Current Position: Tile ${controller.currentPosition.value}',
              style: TextStyle(
                fontSize: 14.sp,
                color: PourRichColors.textPrimary,
              ),
            ),
          ),
          Obx(() {
            final position = controller.currentPosition.value;
            final tileInfo = _getTileInfo(position);
            return Row(
              children: [
                Text(tileInfo['emoji']!, style: TextStyle(fontSize: 16.sp)),
                SizedBox(width: 4.w),
                Text(
                  tileInfo['name']!,
                  style: TextStyle(fontSize: 14.sp, color: tileInfo['color']),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGameCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRulesSection(),
          SizedBox(height: 20.h),
          Obx(
            () => PourRichWaterCup(
              waterAmount: controller.currentWaterAmount.value,
              maxAmount: 1000,
            ),
          ),
          SizedBox(height: 20.h),
          _buildInputDisplay(),
          SizedBox(height: 12.h),
          _buildKeyboardOrResult(),
        ],
      ),
    );
  }

  Widget _buildRulesSection() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: PourRichColors.blue,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info, color: Colors.white, size: 14.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'Guess Water Rules: Enter exact value (0-1000ml). Match exactly to move forward 1-6 steps randomly',
              style: TextStyle(
                fontSize: 13.sp,
                color: PourRichColors.textPrimary.withOpacity(0.85),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputDisplay() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: PourRichColors.textSecondary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: controller.toggleKeyboardResult,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Obx(
              () => Text(
                controller.guessInput.value.isEmpty
                    ? 'Enter value (0-1000ml)'
                    : '${controller.guessInput.value} ml',
                style: TextStyle(
                  fontSize: controller.guessInput.value.isEmpty ? 16.sp : 24.sp,
                  fontWeight: controller.guessInput.value.isEmpty
                      ? FontWeight.w400
                      : FontWeight.w600,
                  color: controller.guessInput.value.isEmpty
                      ? PourRichColors.textSecondary
                      : PourRichColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardOrResult() {
    return Obx(() {
      if (controller.gameInputState.value == GameInputState.inputting) {
        return AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: controller.showKeyboard.value
              ? PourRichNumberKeyboard(
                  currentValue: controller.guessInput.value,
                  onNumberTap: controller.onKeyboardNumberTap,
                  onDeleteTap: controller.onKeyboardDeleteTap,
                  onConfirmTap: controller.onKeyboardConfirmTap,
                  isVisible: controller.showKeyboard.value,
                )
              : SizedBox.shrink(),
        );
      } else {
        return Column(
          children: [
            Container(
              height: 50.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.onChangeQuestion,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Center(
                    child: Text(
                      'Change Question',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            if (controller.showFeedback.value)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: controller.isGuessCorrect.value
                      ? Color(0xFFE3F2FD)
                      : Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  controller.feedbackMessage.value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: controller.isGuessCorrect.value
                        ? PourRichColors.textPrimary
                        : Color(0xFFC62828),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      }
    });
  }

  Widget _buildGameBoard() {
    return Container(
      height: 320.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(
        () => PourRichGameBoard(
          currentPosition: controller.currentPosition.value,
          animatingPosition: controller.animatingPosition.value,
          isAnimating: controller.isAnimating.value,
          highlightedTile: controller.highlightedTile.value,
        ),
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(_buildHelpDialog());
  }

  Map<String, dynamic> _getTileInfo(int position) {
    final tiles = [
      {'type': 'start', 'number': 1},
      {'type': 'normal', 'number': 2},
      {'type': 'question', 'number': 3},
      {'type': 'normal', 'number': 4},
      {'type': 'empty', 'number': 5},
      {'type': 'forward', 'number': 6},
      {'type': 'question', 'number': 7},
      {'type': 'empty', 'number': 8},
      {'type': 'question', 'number': 9},
      {'type': 'normal', 'number': 10},
      {'type': 'empty', 'number': 11},
      {'type': 'normal', 'number': 12},
      {'type': 'normal', 'number': 13},
      {'type': 'normal', 'number': 14},
      {'type': 'normal', 'number': 15},
      {'type': 'normal', 'number': 16},
      {'type': 'normal', 'number': 17},
      {'type': 'forward', 'number': 18},
      {'type': 'empty', 'number': 19},
      {'type': 'forward', 'number': 20},
      {'type': 'forward', 'number': 21},
      {'type': 'forward', 'number': 22},
      {'type': 'question', 'number': 23},
      {'type': 'question', 'number': 24},
      {'type': 'finish', 'number': 25},
    ];
    if (position < 1) position = 1;
    if (position > tiles.length) position = tiles.length;
    final tile = tiles[position - 1];
    final type = tile['type'] as String;
    switch (type) {
      case 'start':
        return {'emoji': '🏠', 'name': 'Start', 'color': Color(0xFF66BB6A)};
      case 'finish':
        return {'emoji': '🏁', 'name': 'Finish', 'color': Color(0xFF66BB6A)};
      case 'question':
        return {'emoji': '❓', 'name': 'Challenge', 'color': Color(0xFFFF9800)};
      case 'forward':
        return {'emoji': '💰', 'name': 'Bonus', 'color': Color(0xFFFFA726)};
      case 'empty':
        return {'emoji': '🏢', 'name': 'Company', 'color': Color(0xFF9E9E9E)};
      case 'normal':
        return {'emoji': '⭕', 'name': 'Normal', 'color': PourRichColors.blue};
      default:
        return {'emoji': '⭕', 'name': 'Normal', 'color': PourRichColors.blue};
    }
  }

  Widget _buildHelpDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF5F9FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.help_outline, color: Colors.white, size: 32.w),
            ),
            SizedBox(height: 16.h),
            Text(
              'Game Help',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: PourRichColors.textPrimary,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHelpSection(
                      icon: '🎯',
                      title: 'Game Objective',
                      content:
                          'Reach the finish line by guessing exact water amounts.',
                      color: Color(0xFFE3F2FD),
                    ),
                    SizedBox(height: 12.h),
                    _buildHelpSection(
                      icon: '📏',
                      title: 'How to Play',
                      content:
                          'Guess the exact water amount (0-1000ml). Correct guess moves you forward 1-6 steps randomly. Wrong guess gives you a hint!',
                      color: Color(0xFFFFF3E0),
                    ),
                    SizedBox(height: 12.h),
                    _buildHelpSection(
                      icon: '🎲',
                      title: 'Tile Effects',
                      content: '',
                      color: Color(0xFFF3E5F5),
                      children: [
                        _buildTileEffect('💰', 'Forward', 'Extra 1-3 steps'),
                        _buildTileEffect('❓', 'Mystery', 'Random event'),
                        _buildTileEffect('🏢', 'Empty', 'No effect'),
                        _buildTileEffect('🏠', 'Start', 'Game begins'),
                        _buildTileEffect('🏁', 'Finish', 'Victory!'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF29B6F6).withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(24.r),
                  child: Center(
                    child: Text(
                      'Got it!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection({
    required String icon,
    required String title,
    required String content,
    required Color color,
    List<Widget>? children,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: PourRichColors.textPrimary,
                ),
              ),
            ],
          ),
          if (content.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              content,
              style: TextStyle(
                fontSize: 13.sp,
                color: PourRichColors.textPrimary.withOpacity(0.8),
                height: 1.4,
              ),
            ),
          ],
          if (children != null && children.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildTileEffect(String emoji, String name, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 8.w),
          Text(
            '$name: ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: PourRichColors.textPrimary.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
