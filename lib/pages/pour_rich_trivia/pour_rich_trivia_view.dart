import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_trivia_logic.dart';

class PourRichTriviaView extends GetView<PourRichTriviaLogic> {
  const PourRichTriviaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, color: PourRichColors.primary, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              'Discover Trivia',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: PourRichColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: Obx(
        () => ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: controller.triviaList.length,
          itemBuilder: (context, index) {
            final trivia = controller.triviaList[index];
            return _buildTriviaCard(trivia);
          },
        ),
      ),
    );
  }

  Widget _buildTriviaCard(Map<String, String> trivia) {
    return GestureDetector(
      onTap: () => controller.onTriviaCardTap(trivia),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: PourRichColors.cardBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(
                  trivia['icon'] ?? '',
                  style: TextStyle(fontSize: 28.sp),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trivia['title'] ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: PourRichColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    trivia['content'] ?? '',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: PourRichColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: PourRichColors.textSecondary,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}
