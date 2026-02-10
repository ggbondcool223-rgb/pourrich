import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pour_rich/utils/colors.dart';
import 'package:pour_rich/components/text_field.dart';
import 'pour_rich_calculator_logic.dart';

class PourRichCalculatorView extends GetView<PourRichCalculatorLogic> {
  const PourRichCalculatorView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PourRichColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Financial Calculator',
          style: TextStyle(
            color: PourRichColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: PourRichColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildCalculatorTabs(),
          Expanded(
            child: Obx(() {
              switch (controller.selectedCalculator.value) {
                case 'compound':
                  return _buildCompoundInterestCalculator();
                case 'mortgage':
                  return _buildMortgageCalculator();
                case 'retirement':
                  return _buildRetirementCalculator();
                case 'goal':
                  return _buildGoalCalculator();
                default:
                  return const SizedBox();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculatorTabs() {
    return Container(
      height: 70.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            _buildTab('compound', 'Compound\nInterest', Icons.trending_up),
            _buildTab('mortgage', 'Mortgage', Icons.home),
            _buildTab('retirement', 'Retirement', Icons.account_balance),
            _buildTab('goal', 'Goal', Icons.flag),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String key, String label, IconData icon) {
    final isSelected = controller.selectedCalculator.value == key;
    return GestureDetector(
      onTap: () => controller.selectCalculator(key),
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [const Color(0xFF13ec37), const Color(0xFF0ac92d)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.grey[100],
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF13ec37).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : PourRichColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompoundInterestCalculator() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            'Compound Interest',
            'Calculate how your money grows over time with compound interest',
            Icons.trending_up,
            const Color(0xFF13ec37),
          ),
          SizedBox(height: 24.h),
          _buildInputCard(
            'Principal Amount',
            controller.principalController,
            Icons.attach_money,
            'e.g., 10000',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Annual Interest Rate',
            controller.annualRateController,
            Icons.percent,
            'e.g., 5',
            suffix: '%',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Number of Years',
            controller.yearsController,
            Icons.calendar_today,
            'e.g., 10',
          ),
          SizedBox(height: 28.h),
          _buildCalculateButton(controller.calculateCompoundInterest),
          SizedBox(height: 24.h),
          Obx(() {
            if (controller.compoundResult.value > 0) {
              return _buildResultCard('Calculation Result', [
                _buildResultItem(
                  'Future Value',
                  '\$${controller.compoundResult.value.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  const Color(0xFF13ec37),
                ),
                _buildResultItem(
                  'Total Interest Earned',
                  '\$${controller.compoundInterest.value.toStringAsFixed(2)}',
                  Icons.add_circle,
                  const Color(0xFF13ec37),
                ),
              ]);
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildMortgageCalculator() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            'Mortgage Calculator',
            'Calculate your monthly mortgage payment and total interest',
            Icons.home,
            const Color(0xFF2196F3),
          ),
          SizedBox(height: 24.h),
          _buildInputCard(
            'Loan Amount',
            controller.loanAmountController,
            Icons.account_balance,
            'e.g., 300000',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Annual Interest Rate',
            controller.loanRateController,
            Icons.percent,
            'e.g., 3.5',
            suffix: '%',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Loan Term',
            controller.loanYearsController,
            Icons.event,
            'e.g., 30',
            suffix: 'years',
          ),
          SizedBox(height: 28.h),
          _buildCalculateButton(controller.calculateMortgage),
          SizedBox(height: 24.h),
          Obx(() {
            if (controller.monthlyPayment.value > 0) {
              return _buildResultCard('Payment Breakdown', [
                _buildResultItem(
                  'Monthly Payment',
                  '\$${controller.monthlyPayment.value.toStringAsFixed(2)}',
                  Icons.payment,
                  const Color(0xFF2196F3),
                ),
                _buildResultItem(
                  'Total Payment',
                  '\$${controller.totalPayment.value.toStringAsFixed(2)}',
                  Icons.account_balance_wallet,
                  const Color(0xFF2196F3),
                ),
                _buildResultItem(
                  'Total Interest',
                  '\$${controller.totalInterest.value.toStringAsFixed(2)}',
                  Icons.add_chart,
                  const Color(0xFFFF9800),
                ),
              ]);
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildRetirementCalculator() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            'Retirement Calculator',
            'Estimate how much you need to save for retirement',
            Icons.account_balance,
            const Color(0xFF9C27B0),
          ),
          SizedBox(height: 24.h),
          _buildInputCard(
            'Current Age',
            controller.currentAgeController,
            Icons.cake,
            'e.g., 30',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Retirement Age',
            controller.retirementAgeController,
            Icons.beach_access,
            'e.g., 65',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Monthly Expense',
            controller.monthlyExpenseController,
            Icons.shopping_cart,
            'e.g., 3000',
          ),
          SizedBox(height: 28.h),
          _buildCalculateButton(controller.calculateRetirement),
          SizedBox(height: 24.h),
          Obx(() {
            if (controller.retirementNeeded.value > 0) {
              return _buildResultCard('Retirement Plan', [
                _buildResultItem(
                  'Retirement Fund Needed',
                  '\$${controller.retirementNeeded.value.toStringAsFixed(2)}',
                  Icons.savings,
                  const Color(0xFF9C27B0),
                ),
                _buildResultItem(
                  'Years in Retirement',
                  '${controller.yearsInRetirement.value} years',
                  Icons.timer,
                  const Color(0xFF9C27B0),
                ),
              ]);
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildGoalCalculator() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            'Goal Calculator',
            'Calculate how long it takes to reach your financial goal',
            Icons.flag,
            const Color(0xFFFF5722),
          ),
          SizedBox(height: 24.h),
          _buildInputCard(
            'Goal Amount',
            controller.goalAmountController,
            Icons.stars,
            'e.g., 50000',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Monthly Contribution',
            controller.monthlyContributionController,
            Icons.savings,
            'e.g., 500',
          ),
          SizedBox(height: 16.h),
          _buildInputCard(
            'Expected Annual Return',
            controller.expectedReturnController,
            Icons.trending_up,
            'e.g., 7',
            suffix: '%',
          ),
          SizedBox(height: 28.h),
          _buildCalculateButton(controller.calculateGoal),
          SizedBox(height: 24.h),
          Obx(() {
            if (controller.yearsNeeded.value > 0) {
              return _buildResultCard('Timeline', [
                _buildResultItem(
                  'Years Needed',
                  controller.yearsNeeded.value.toStringAsFixed(1),
                  Icons.calendar_view_month,
                  const Color(0xFFFF5722),
                ),
                _buildResultItem(
                  'Months Needed',
                  controller.monthsNeeded.value.toStringAsFixed(0),
                  Icons.calendar_today,
                  const Color(0xFFFF5722),
                ),
              ]);
            }
            return const SizedBox();
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: PourRichColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: PourRichColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
    String label,
    RxString controller,
    IconData icon,
    String hint, {
    String? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
            child: Row(
              children: [
                Icon(icon, size: 18.sp, color: const Color(0xFF13ec37)),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: PourRichColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: MyTextField(
                    value: controller.value,
                    hintText: hint,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    isNumber: true,
                    onChange: (value) => controller.value = value,
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                  ),
                ),
                if (suffix != null)
                  Padding(
                    padding: EdgeInsets.only(right: 16.w, bottom: 14.h),
                    child: Text(
                      suffix,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: PourRichColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton(VoidCallback onPressed) {
    return Container(
      height: 54.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF13ec37), Color(0xFF0ac92d)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF13ec37).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14.r),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate, color: Colors.white, size: 22.sp),
                SizedBox(width: 10.w),
                Text(
                  'Calculate',
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

  Widget _buildResultCard(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xFF13ec37),
                size: 24.sp,
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: PourRichColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResultItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: PourRichColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: PourRichColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
