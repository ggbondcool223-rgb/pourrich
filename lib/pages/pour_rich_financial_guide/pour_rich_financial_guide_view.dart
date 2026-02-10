import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'pour_rich_financial_guide_logic.dart';

class PourRichFinancialGuideView extends GetView<PourRichFinancialGuideLogic> {
  const PourRichFinancialGuideView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: controller.guides.length,
                itemBuilder: (context, index) {
                  final guide = controller.guides[index];
                  return _buildGuideCard(guide);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 50.h,
        bottom: 24.h,
        left: 20.w,
        right: 20.w,
      ),
      decoration: const BoxDecoration(color: PourRichColors.gold),
      child: Column(
        children: [
          Text(
            'Financial Planning Guide',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Let your life accumulate wealth step by step',
            style: TextStyle(
              fontSize: 14.sp,
              color: PourRichColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'For reference only. Investment is risky. Please be cautious',
            style: TextStyle(
              fontSize: 11.sp,
              color: PourRichColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(Map<String, dynamic> guide) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Color(guide['bgColor']),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Color(guide['borderColor']), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(guide['icon'], style: TextStyle(fontSize: 40.sp)),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide['stage'],
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: PourRichColors.textPrimary,
                    ),
                  ),
                  Text(
                    guide['age'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: PourRichColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            guide['description'],
            style: TextStyle(
              fontSize: 14.sp,
              color: PourRichColors.textPrimary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            (guide['advice'] as List).length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('💰', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      guide['advice'][index],
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: PourRichColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Suggested Investment Allocation:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: PourRichColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...List.generate((guide['allocation'] as List).length, (index) {
            final allocation = guide['allocation'][index];
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    allocation['type'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: PourRichColors.textPrimary,
                    ),
                  ),
                  Text(
                    allocation['percentage'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: PourRichColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
