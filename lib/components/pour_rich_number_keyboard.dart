import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pour_rich/utils/colors.dart';

class PourRichNumberKeyboard extends StatelessWidget {
  final String currentValue;
  final Function(String) onNumberTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onConfirmTap;
  final bool isVisible;
  const PourRichNumberKeyboard({
    super.key,
    required this.currentValue,
    required this.onNumberTap,
    required this.onDeleteTap,
    required this.onConfirmTap,
    this.isVisible = true,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildNumberKey('1'),
              SizedBox(width: 8.w),
              _buildNumberKey('2'),
              SizedBox(width: 8.w),
              _buildNumberKey('3'),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildNumberKey('4'),
              SizedBox(width: 8.w),
              _buildNumberKey('5'),
              SizedBox(width: 8.w),
              _buildNumberKey('6'),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildNumberKey('7'),
              SizedBox(width: 8.w),
              _buildNumberKey('8'),
              SizedBox(width: 8.w),
              _buildNumberKey('9'),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildDeleteKey(),
              SizedBox(width: 8.w),
              _buildNumberKey('0'),
              SizedBox(width: 8.w),
              _buildConfirmKey(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberKey(String number) {
    return Expanded(
      child: Container(
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
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onNumberTap(number),
            borderRadius: BorderRadius.circular(12.r),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: PourRichColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Expanded(
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onDeleteTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Center(
              child: Icon(
                Icons.backspace_outlined,
                size: 24.w,
                color: PourRichColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmKey() {
    return Expanded(
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: PourRichColors.primary,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: PourRichColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onConfirmTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Center(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
